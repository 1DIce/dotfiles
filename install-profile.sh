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


while IFS= read -r config; do
    CONFIGS+=" ${config}"
done < "${META_DIR}/${PROFILES_DIR}/$1"

shift

for config in ${CONFIGS} ${@}; do
    echo -e "\nConfigure $config"
    # create temporary file
    configFile="$(mktemp)"
    suffix="-sudo"
    echo -e "$(<"${BASE_DIR}/${META_DIR}/${BASE_CONFIG}${CONFIG_SUFFIX}")\n$(<"${BASE_DIR}/${META_DIR}/${CONFIG_DIR}/${config%"$suffix"}${CONFIG_SUFFIX}")" > "$configFile"

    cmd=("${BASE_DIR}/${META_DIR}/${DOTBOT_DIR}/${DOTBOT_BIN}" -d "${BASE_DIR}" --plugin-dir ${META_DIR}/dotbot-apt-get --plugin-dir ${META_DIR}/dotbot-crossplatform -c "$configFile")

    if [[ $config == *"sudo"* ]]; then
        cmd=(sudo "${cmd[@]}")
    fi

    "${cmd[@]}"
    rm -f "$configFile"
done

cd "${BASE_DIR}"