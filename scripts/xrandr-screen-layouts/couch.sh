#!/bin/sh

xrandr \
  --output DisplayPort-0 --off \
  --output DisplayPort-1 --off \
  --output DisplayPort-2 --off \
  --output HDMI-A-0 --auto --primary
