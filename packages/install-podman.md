add source **make sure the version is correct**
```
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /' > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list"

wget -nv https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_20.04/Release.key -O- | sudo apt-key add -
```

install podman
```
sudo apt-get update
sudo apt-get install podman
```

install podman-compose
https://github.com/containers/podman-compose
```
sudo apt install python3-pip
pip3 install podman-compose
```
