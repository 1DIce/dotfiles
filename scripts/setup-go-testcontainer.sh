#!/usr/bin/env bash

docker context use colima

sudo ln -sf "$HOME/.config/colima/default/docker.sock /var/run/docker.sock"

colima stop

colima start --network-address
