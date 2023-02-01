#!/usr/bin/env bash

set -e

scriptDir=$(dirname "$(realpath "$0")")
repoName="cantino/mcfly"
tag=$("$scriptDir"/github-latest-tag.sh "$repoName" )
platform="unknown-linux-musl"
target="$(uname -m)-$platform"
downloadUrl="https://github.com/$repoName/releases/download/$tag/mcfly-$tag-$target.tar.gz"
installDir="$HOME/bin"

rm -f "$installDir"/mcfly
curl -sL "$downloadUrl" | tar -C "$installDir" -xz
chmod +x "$installDir"/mcfly
