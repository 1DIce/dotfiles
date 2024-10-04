#!/bin/sh
# gsettings set org.gnome.desktop.interface scaling-factor 2
# gsettings set org.gnome.settings-daemon.plugins.xsettings overrides "{'Gdk/WindowScalingFactor': <2>}"

# xrandr \
#   --output DisplayPort-1 --mode 1920x1080 --rotate normal --fb 11520x3240 --scale 2.0x2.0 --panning 5760x3240 \
#   --output DisplayPort-0 --primary --mode 3840x2160 --right-of DisplayPort-1 --rotate normal --fb 11520x3240 --scale 1.5x1.5 --panning 5760x6480 \
#   --output DisplayPort-2 --off \
#   --output HDMI-A-0 --off 
# xrandr \
#   --output DisplayPort-1 --mode 1920x1080 --rotate normal \
#   --output DisplayPort-0 --primary --mode 3840x2160 --right-of DisplayPort-1 --rotate normal --scale 0.75x0.75 \
#   --output DisplayPort-2 --off \
#   --output HDMI-A-0 --off 
# xrandr \
#   --dpi 192 --fb 7680x4320 \
#   --output DisplayPort-0 --primary --mode 3840x2160 --pos 3840x0 --rotate normal --panning 3840x2160+3840+0 \
#   --output DisplayPort-1 --scale 2x2 --rotate normal \
#   --output DisplayPort-2 --off \
#   --output HDMI-A-0 --off 
xrandr \
  --dpi 192 --fb 7680x4320 \
  --output DisplayPort-1 --auto --scale 2x2 \
  --output DisplayPort-0 --auto --primary --panning 3840x2160+3840+0 --right-of DisplayPort-1 \
  --output DisplayPort-2 --off \
  --output HDMI-A-0 --off 
