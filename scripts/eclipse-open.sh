#! /usr/bin/env bash

gitRootDir=$(git rev-parse --show-toplevel)

$gitRootDir/../eclipse/eclipse &
