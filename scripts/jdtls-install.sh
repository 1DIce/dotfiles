#!/usr/bin/env bash

JDTLS_ROOT="$HOME/.local/share/java/jdtls"
JDTLS_EXTENSION_ROOT="$HOME/.local/share/java/jdtls-extensions"

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

function install_extensions {
  rm -rf "$JDTLS_EXTENSION_ROOT"
  mkdir -p "$JDTLS_EXTENSION_ROOT"
  cd "$JDTLS_EXTENSION_ROOT"

  java_debug_install

  java_test_install

  pde_support_install
}

function java_debug_install {
  git clone https://github.com/microsoft/java-debug.git vscode-java-debug
  pushd vscode-java-debug > /dev/null
  ./mvnw clean install
  popd > /dev/null
}

function java_test_install {
  git clone https://github.com/microsoft/vscode-java-test.git
  pushd vscode-java-test > /dev/null
  npm install
  npm run build-plugin
  popd > /dev/null
}

function pde_support_install {
  echo "FAILED to install PDE support"
  # TODO download release from github and unpack that
}

if [ "$1" == "extensions" ]; then
  install_extensions
else
  jdtls_install
  install_extensions
fi



