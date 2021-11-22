#!/usr/bin/env bash

set -e

BASE_CONFIG="base"
CONFIG_SUFFIX=".yml"

META_DIR="meta"
CONFIG_DIR="configs"
PROFILES_DIR="profiles"

DOTBOT_DIR="dotbot"
DOTBOT_BIN="bin/dotbot"

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


cd "${BASE_DIR}"
git submodule update --init --recursive --remote

# Parsing addtional arguments
PARSED_ARGUMENTS=$(getopt -o o: --long only:,except: -- "$@")
VALID_ARGUMENTS=$?
if [ "$VALID_ARGUMENTS" != "0" ]; then
  usage
fi

echo "PARSED_ARGUMENTS is $PARSED_ARGUMENTS"
eval set -- "$PARSED_ARGUMENTS"

DOTBOT_OPTIONS=""
while :
do
  case "$1" in
    -o | --only) DOTBOT_OPTIONS="${DOTBOT_OPTIONS} $1 $2"  ; shift 2 ;;
    --except) DOTBOT_OPTIONS="${DOTBOT_OPTIONS} $1 $2"  ; shift 2 ;;
    # -- means the end of the arguments; drop this, and break out of the while loop
    --) shift; break ;;
  esac
done

echo "$DOTBOT_OPTIONS"

for config in ${@}; do

  # create temporary file
  configFile="$(mktemp)"
  suffix="-sudo"
  echo -e "$(<"${BASE_DIR}/${META_DIR}/${BASE_CONFIG}${CONFIG_SUFFIX}")\n$(<"${BASE_DIR}/${META_DIR}/${CONFIG_DIR}/${config%"$suffix"}${CONFIG_SUFFIX}")" > "$configFile"

  cmd=("${BASE_DIR}/${META_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" ${DOTBOT_OPTIONS} -d "${BASE_DIR}" --plugin-dir ${META_DIR}/dotbot-apt-get --plugin-dir ${META_DIR}/dotbot-crossplatform -c "$configFile")

  if [[ $config == *"sudo"* ]]; then
    cmd=(sudo "${cmd[@]}")
  fi

  "${cmd[@]}"
  rm -f "$configFile"
done

cd "${BASE_DIR}"
