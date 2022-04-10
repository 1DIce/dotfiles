#! /usr/bin/env bash

sudo service ssh start

WSL_IP=$(wsl.exe hostname -I | xargs) # xargs is used to strip whitespace

(
	trap 'kill 0' INT
	ssh.exe -R 9980:localhost:9980 -N lars@"${WSL_IP}" &
	ssh.exe -R 8080:localhost:8080 -N lars@"${WSL_IP}" &
	# forward chrome remote debugging port
	ssh.exe -R 9222:localhost:9222 -N lars@"${WSL_IP}"
)
