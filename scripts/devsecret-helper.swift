// Backend for devsecret.sh, compiled by `devsecret init`.
// Items are created by this binary, so the keychain ACL trusts only it: other
// programs (including `security`) get a keychain password dialog instead.
//
//   devsecret-helper get <keychain-path> <name>   Touch ID, then print the secret
//   devsecret-helper getjson <keychain-path> <name>...
//                                                 one Touch ID, then print the secrets as a JSON object
//   devsecret-helper set <keychain-path> <name>   store stdin as the secret
//   devsecret-helper list <keychain-path>         print all secret names
//   devsecret-helper lock                         forget this session's grants
//
// A successful Touch ID check grants that secret to the current terminal session
// for an hour. Grants are files signed with a key that only this binary can read
// from the keychain, so other processes cannot forge them.
import CryptoKit
import Foundation
import LocalAuthentication
import Security

let usage = "usage: devsecret-helper get|set <keychain-path> <name> | getjson <keychain-path> <name>... | list <keychain-path> | lock"
let grantTTL = 3600
let grantKeyName = "devsecret.grant-key"
let grantDir = FileManager.default.temporaryDirectory.appendingPathComponent("devsecret-grants")

func fail(_ message: String, _ code: Int32 = 1) -> Never {
    FileHandle.standardError.write("devsecret: \(message)\n".data(using: .utf8)!)
    exit(code)
}

func describe(_ status: OSStatus) -> String {
    SecCopyErrorMessageString(status, nil) as String? ?? "status \(status)"
}

func authenticate(_ reason: String) {
    let context = LAContext()
    let done = DispatchSemaphore(value: 0)
    var authenticated = false
    context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, _ in
        authenticated = success
        done.signal()
    }
    done.wait()
    guard authenticated else { fail("authentication failed") }
}

func openKeychain(_ path: String) -> SecKeychain {
    var keychain: SecKeychain?
    guard SecKeychainOpen(path, &keychain) == errSecSuccess, let keychain else {
        fail("cannot open keychain \(path)")
    }
    return keychain
}

func itemQuery(_ keychain: SecKeychain, _ name: String) -> [String: Any] {
    [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: name,
        kSecAttrAccount as String: NSUserName(),
        kSecMatchSearchList as String: [keychain],
    ]
}

func readItem(_ keychain: SecKeychain, _ name: String) -> (Data?, OSStatus) {
    var query = itemQuery(keychain, name)
    query[kSecReturnData as String] = true
    query[kSecMatchLimit as String] = kSecMatchLimitOne
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    return (item as? Data, status)
}

func writeItem(_ keychain: SecKeychain, _ name: String, _ value: Data) -> OSStatus {
    let status = SecItemUpdate(itemQuery(keychain, name) as CFDictionary, [kSecValueData as String: value] as CFDictionary)
    guard status == errSecItemNotFound else { return status }
    let item: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrService as String: name,
        kSecAttrAccount as String: NSUserName(),
        kSecUseKeychain as String: keychain,
        kSecValueData as String: value,
    ]
    return SecItemAdd(item as CFDictionary, nil)
}

func grantKey(_ keychain: SecKeychain) -> SymmetricKey {
    if case let (data?, errSecSuccess) = readItem(keychain, grantKeyName) {
        return SymmetricKey(data: data)
    }
    let key = SymmetricKey(size: .bits256)
    let status = writeItem(keychain, grantKeyName, key.withUnsafeBytes { Data($0) })
    guard status == errSecSuccess else { fail("cannot store grant key: \(describe(status))") }
    return key
}

// The session id alone can be reused by a later session, so the leader's start time is part of the scope.
func sessionScope() -> String? {
    let sid = getsid(0)
    guard sid > 0 else { return nil }
    var info = kinfo_proc()
    var size = MemoryLayout<kinfo_proc>.stride
    var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, sid]
    guard sysctl(&mib, 4, &info, &size, nil, 0) == 0, size > 0 else { return nil }
    let start = info.kp_proc.p_un.__p_starttime
    return "\(sid)-\(start.tv_sec)-\(start.tv_usec)"
}

func grantFile(_ scope: String, _ name: String) -> URL {
    let nameHash = SHA256.hash(data: Data(name.utf8)).map { String(format: "%02x", $0) }.joined()
    return grantDir.appendingPathComponent("\(scope)-\(nameHash)")
}

func grantPayload(_ scope: String, _ name: String, _ expiry: Int) -> Data {
    Data("\(scope)|\(name)|\(expiry)".utf8)
}

func hasGrant(_ keychain: SecKeychain, _ scope: String, _ name: String) -> Bool {
    guard let content = try? String(contentsOf: grantFile(scope, name), encoding: .utf8) else { return false }
    let parts = content.split(separator: " ")
    guard parts.count == 2, let expiry = Int(parts[0]), let mac = Data(base64Encoded: String(parts[1])) else { return false }
    let now = Int(Date().timeIntervalSince1970)
    guard now < expiry, expiry <= now + grantTTL else { return false }
    return HMAC<SHA256>.isValidAuthenticationCode(mac, authenticating: grantPayload(scope, name, expiry), using: grantKey(keychain))
}

func writeGrant(_ keychain: SecKeychain, _ scope: String, _ name: String) {
    let expiry = Int(Date().timeIntervalSince1970) + grantTTL
    let mac = Data(HMAC<SHA256>.authenticationCode(for: grantPayload(scope, name, expiry), using: grantKey(keychain)))
    try? FileManager.default.createDirectory(at: grantDir, withIntermediateDirectories: true, attributes: [.posixPermissions: 0o700])
    let file = grantFile(scope, name)
    let written = FileManager.default.createFile(
        atPath: file.path, contents: Data("\(expiry) \(mac.base64EncodedString())".utf8), attributes: [.posixPermissions: 0o600])
    if !written { FileHandle.standardError.write("devsecret: cannot write grant \(file.path)\n".data(using: .utf8)!) }
}

func removeGrants(matching prefix: String?) {
    let now = Int(Date().timeIntervalSince1970)
    let files = (try? FileManager.default.contentsOfDirectory(at: grantDir, includingPropertiesForKeys: nil)) ?? []
    for file in files {
        let expired = (try? String(contentsOf: file, encoding: .utf8)).flatMap { Int($0.split(separator: " ").first ?? "") }.map { $0 <= now } ?? true
        if expired || prefix.map({ file.lastPathComponent.hasPrefix($0) }) == true {
            try? FileManager.default.removeItem(at: file)
        }
    }
}

func requireUserName(_ name: String) {
    if name == grantKeyName { fail("\"\(name)\" is reserved") }
}

let args = CommandLine.arguments
switch (args.count > 1 ? args[1] : "", args.count) {
case ("get", 4):
    let keychain = openKeychain(args[2])
    let name = args[3]
    requireUserName(name)
    let scope = sessionScope()
    let granted = scope.map { hasGrant(keychain, $0, name) } ?? false
    if !granted { authenticate("read dev secret \"\(name)\"") }
    let (data, status) = readItem(keychain, name)
    guard status == errSecSuccess, let data, let secret = String(data: data, encoding: .utf8) else {
        fail("cannot read \"\(name)\": \(describe(status))")
    }
    if !granted, let scope {
        removeGrants(matching: nil)
        writeGrant(keychain, scope, name)
    }
    print(secret, terminator: "")

case ("getjson", 4...):
    let keychain = openKeychain(args[2])
    let names = Set(args[3...]).sorted()
    names.forEach(requireUserName)
    let scope = sessionScope()
    let ungranted = names.filter { name in !(scope.map { hasGrant(keychain, $0, name) } ?? false) }
    if !ungranted.isEmpty {
        authenticate("read dev secrets \(ungranted.map { "\"\($0)\"" }.joined(separator: ", "))")
    }
    var secrets: [String: String] = [:]
    for name in names {
        let (data, status) = readItem(keychain, name)
        guard status == errSecSuccess, let data, let secret = String(data: data, encoding: .utf8) else {
            fail("cannot read \"\(name)\": \(describe(status))")
        }
        secrets[name] = secret
    }
    if !ungranted.isEmpty, let scope {
        removeGrants(matching: nil)
        for name in ungranted { writeGrant(keychain, scope, name) }
    }
    let json = try! JSONSerialization.data(withJSONObject: secrets, options: [.sortedKeys, .withoutEscapingSlashes])
    print(String(decoding: json, as: UTF8.self))

case ("set", 4):
    let keychain = openKeychain(args[2])
    let name = args[3]
    requireUserName(name)
    var value = FileHandle.standardInput.readDataToEndOfFile()
    if value.last == UInt8(ascii: "\n") { value.removeLast() }
    guard !value.isEmpty else { fail("empty secret") }
    let status = writeItem(keychain, name, value)
    guard status == errSecSuccess else { fail("cannot store \"\(name)\": \(describe(status))") }

case ("list", 3):
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecMatchSearchList as String: [openKeychain(args[2])],
        kSecReturnAttributes as String: true,
        kSecMatchLimit as String: kSecMatchLimitAll,
    ]
    var items: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &items)
    if status == errSecItemNotFound { exit(0) }
    guard status == errSecSuccess, let attributes = items as? [[String: Any]] else {
        fail("cannot list secrets: \(describe(status))")
    }
    let names = Set(attributes.compactMap { $0[kSecAttrService as String] as? String }).subtracting([grantKeyName])
    for name in names.sorted() { print(name) }

case ("lock", 2):
    guard let scope = sessionScope() else { fail("cannot determine terminal session") }
    removeGrants(matching: "\(scope)-")

default:
    fail(usage, 2)
}
