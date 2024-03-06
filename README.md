# Dotfiles

## Getting started - Ubuntu
1. setup shell proper configuration `./install-profile.sh ubuntu-shell`
2. install zsh and switch to it `sudo apt update && sudo apt install zsh -y && chsh -s /usr/bin/zsh`
3. setup the rest of the dotfiles and software `.install-profile ubuntu`

## Requirements for installing windows tools
- [scoop](scoop.sh) is installed

## installing a profile
`./install-profile <profile> [<configs...>]`

## installing a single config
`./install-standalone <configs...>`

You can also invoke a single configuration as a sudoer by adding -sudo to the end of a configuration
`./install-standalone some-config-sudo some-other-config`


## Adding a new git submodule
add the submodule to the repository:
````
cd ~/dotfiles 
git submodule add --depth 1 <repo-url> ./libs/<repo-name>
git config -f .gitmodules submodule.path/to/submodule.shallow true
git config -f .gitmodules submodule.path/to/submodule.ignore dirty

``````
modify the install.conf.yml accordingly

## Additional resources
- https://github.com/anishathalye/dotbot/wiki/Tips-and-Tricks#how-can-i-have-different-groups-of-tasks-for-different-hosts-with-different-configurations
