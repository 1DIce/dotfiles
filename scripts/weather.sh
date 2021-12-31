#!/bin/sh

LOCATION="$*" # all input arguments separated by space
LOCATION=$(echo "$LOCATION" | sed 's| |+|g')

if [ -z "$LOCATION" ]
then
  LOCATION="Karlsruhe"
fi

# docs https://github.com/chubin/wttr.in
curl "wttr.in/$LOCATION?mqF&lang=de"
