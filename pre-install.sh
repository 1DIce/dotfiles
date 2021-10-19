#!/usr/bin/env bash

set -e

CONFIG="pre-install.conf.yaml"
DOTBOT_APT_GET="libs/dotbot-apt-get/aptget.py"

DOTBOT_BIN="bin/dotbot"
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


"${BASEDIR}/install.sh -p ${BASEDIR}/${DOTBOT_APT_GET} -c ${BASEDIR}/${CONFIG}" 
