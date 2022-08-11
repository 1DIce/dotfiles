#! /usr/bin/env bash

# The script makes windows ports available from inside wsl.
# To work the windows public ssh key needs to be copy to the wsl

serivceStatus=$(service ssh status)
if [[ $serivceStatus =~ 'not running' ]]; then
  echo "ERROR ssh service not running in wsl! start it by running 'sudo service ssh start'"
  exit 1
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
