#! /usr/bin/env bash

serivceStatus=$(service ssh status)
if [[ $serivceStatus = 'not running' ]]; then
	sudo service ssh start
fi

WSL_IP=$(wsl.exe hostname -I | xargs) # xargs is used to strip whitespace

if [[ $# -eq 1 ]]; then
	port=$1
else
	# forward 9222 for chrome remote debugging port
	port=$(echo "8080\n9980\n9222" | fzf)
fi

(
	trap 'kill 0' INT
	ssh.exe -R "${port}:localhost:${port}" -N lars@"${WSL_IP}"
)
