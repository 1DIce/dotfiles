#/usr/bin/env bash

JDTLS_ROOT="$HOME/.local/share/java/jdtls"

function jdtls_install {
	echo 'Installing jdtls...'
	if [ -d "$JDTLS_ROOT" ]; then
		echo "Jdtls installation found at $JDTLS_ROOT, aborting installation" >>/dev/stderr
		return 1
	fi

	local latest=$(curl -Ls 'http://download.eclipse.org/jdtls/snapshots/latest.txt')
	echo "${latest%.tar.gz} is going to be installed"

	mkdir -p "$JDTLS_ROOT"
	cd "$JDTLS_ROOT"

	curl -L "http://download.eclipse.org/jdtls/snapshots/$latest" >"$latest"
	tar -xf "$latest"
	rm "$latest"
	chmod -R 755 "$JDTLS_ROOT"
	chmod -R 777 "$JDTLS_ROOT"/config_*

	local equinox_launcher=$(find -type f -name 'org.eclipse.equinox.launcher_*' 2>/dev/null)
	if [[ ! -f "$equinox_launcher" ]]; then
		echo 'JDTLS installation failure' >>/dev/stderr
		return 1
	fi

	echo 'JDTLS installation succesful'
	return 0
}

jdtls_install
