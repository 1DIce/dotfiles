#! /usr/bin/env bash

gitReviewBase=$1
git-madge image --base "$gitReviewBase" --dpi 400 --ts-config ./tsconfig.json --style solarized-dark --extensions ts,js --exclude "\.spec\.ts$" .
