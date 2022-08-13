#!/usr/bin/env bash

if [ "$(expr substr $(uname -s) 1 10)" == "MINGW64_NT" ]; then
      rm -rf $LOCALAPPDATA/CAS/Merlin
fi
