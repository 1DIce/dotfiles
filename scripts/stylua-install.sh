#!/usr/bin/env bash

STYLUA_EXECUTABLE="stylua"
STYLUA_ZIP="stylua-linux.zip"

if [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]]; then
  STYLUA_EXECUTABLE="stylua.exe"
  STYLUA_ZIP="stylua-win64.zip"
fi

pushd ~/bin
  rm ./$STYLUA_EXECUTABLE

  curl -OL https://github.com/JohnnyMorganz/StyLua/releases/latest/download/$STYLUA_ZIP

  unzip -q ./$STYLUA_ZIP

  rm ./$STYLUA_ZIP

  chmod +x ./$STYLUA_EXECUTABLE
popd > /dev/null
