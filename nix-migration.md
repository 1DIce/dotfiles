# Migration to nix-env

## install nix-env
- make sure systemd=true for wsl installs and reboot wsl if it was not set yet
  - running `.install-standalone wsl` should copy the new wsl.conf
- `./install-standalone.sh nix`
- restart shell

## apt
- search for apt install uninstall and move to nix-env
- uninstall: 
- `sudo apt remove fd-find unzip trash-cli bat ripgrep jq shellcheck imagemagick imagemagick-doc graphviz`



## pipx
- `pipx uninstall-all`

## Brew
### uninstall brew
- `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"`
- https://github.com/homebrew/install?tab=readme-ov-file#uninstall-homebrew
- `rm -rf /home/linuxbrew/`

- install all the packages via nix

##  Volta
### uninstall volta
- `rm -rf ~/.volta`


## fzf
- [ ] remove symlink ~/.fzf
- [ ] remove submodule

## powerlevel10k
- [ ] remove submodul

## gitui
- uninstall gitui rm from ~/bin/

## stylua
- [x] remove installer script
- remove from ~/bin
- no need to migrate is automatically installed by mason

## mcfly
- [x] remove install script 
- remove from disk

## shfmt
- [x] remove install config
- [x] no need to migrate, gets installed by mason

## tmux
- [x] update install config
- `rm -f ~/bin/tmux`

# After uninstalling 
- run `./install-standalone.sh cmd-tools-nix`

- run `./install-standalone.sh pipx` 
- run `./install-standalone.sh python-black` 

- run `./install-standalone.sh volta` 
- rerun `./install-standalone.sh cmd-tools-npm`

- run `./install-standalone.sh gitui` 
- run `./install-standalone.sh tmux` 

