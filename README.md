![Banner](banner.png)

This is my personal dotfiles repo. It houses the configuration of my development setup for multiple operating systems (Pop-Os Linux, Wsl and Windows). Feel free to browse the repo for inspiration, but keep in mind that things are personalized and might not work out of the box on your system when copying.
You can read more about the concept of dotfiles at [dotfiles.github.io](https://dotfiles.github.io)

## Highlights
- Crossplatform support for `Linux(Pop-Os)`, `Windows` and `Wsl(Ubuntu)`
- `Dotbot` for installation and dependency management 
  - Links all configuration files and scripts to the correct locations
  - Installs additional software
- Highly customized `Neovim` editor for coding
- `Tmux` for session management (not on Windows)


## Repository layout
The repository layout is pretty straight forward the following graph gives an overview of the most important parts:

``` plain
+- bash/
  | -- bashrc                              - .bashrc for linux
  | -- wind_bashrc                         - .bashrc used for git bash on windows
+- meta/                                   - everything related to dotbot
  | -- base.yml                            - base dotbot config. All other configs inherit this one
  | +- configs/                            - all my dotbot configurations for different topics and tools
  | +- profile/                            - my dotbot profiles
  | +- dotbot/                             - dotbot repot as a git submodule
  | +- dotbot-crossplatform/               - dotbot plugin for making platform specifc configuration easier
+- nvim/                                   - my `neovim` config written in `lua`
+- libs/                                   - git submodules of software used by this configuration
+- git/                                    - my git config split over multiple files to support multiple environments
+- gitui/               
  | key_bindings.ron                       - vim key bindings for `gitui`
+- scripts/                                - collection of my scripts
  | +- wsl/
  |   | -- wsl-forward-windows-port.sh     - script to forward ports from windows to wsl
  | -- git-create-worktree.sh              - script to create a new worktree in a git repo
  | -- tmux-sessionizer.sh                 - script to create and switch tmux sessions based on directories
+- tmux/
  | -- tmux.conf
+- vrapper/ 
  | -- vrapperrc                           - config file for vrapper a vim plugin for eclipse
+- windows/                                - some windows sepcific configuration files
+- wsl/                                    - wsl2 sepcific configuration files
  | -- wsl.conf                            - configuration file placed inside the wsl under `/etc/wsl.conf`
  | -- wslconfig                           - configuration file places inside windows under `~/.wslconfig`
+- zsh/                                    - contains zsh configuration files
-- installation-profile.sh                 - script to install a dotbot profile
-- installation-standalone.sh              - script to install a dotbot config
```


# Installation

## Installation on Ubuntu and Wsl
1. Clone this repo into `~/dotfiles` by running `cd ~ && git clone https://github.com/1DIce/dotfiles.git`
2. Setup shell proper configuration `./install-profile.sh ubuntu-shell`
3. Install zsh and switch to it `sudo apt update && sudo apt install zsh -y && chsh -s /usr/bin/zsh`
4. **Restart your terminal** to start using zsh. It is required for the rest of the installation to work properly.
5. Setup the rest of the dotfiles and software `.install-profile ubuntu`

## Installation on Windows
1. Make sure that [scoop](scoop.sh) is installed on the system. Dotbot will use it to install dependencies
2. Make sure you are using [git-bash](https://gitforwindows.org/) to run the installation
3. Clone this repo into `~/dotfiles` by running `cd ~ && git clone https://github.com/1DIce/dotfiles.git`
4. Run the dotbot profile for windows to install everything `./install-profile.sh windows`

# Additional notes

## installing a dotbot profile
`./install-profile <profile> [<configs...>]`
The possible values for `profile` are the files in `meta/profiles/`

## installing a single dotbot config
`./install-standalone <configs...>`
The possible values for `configs` are the files in `meta/configs/`

You can also invoke a single configuration as a sudoer by adding -sudo to the end of a configuration
`./install-standalone some-config-sudo some-other-config`


## Adding a new git submodule
Add the submodule to the repository by running:
```
cd ~/dotfiles 
git submodule add --depth 1 <repo-url> ./libs/<repo-name>
git config -f .gitmodules submodule.path/to/submodule.shallow true
git config -f .gitmodules submodule.path/to/submodule.ignore dirty
```

Modify the install.conf.yml accordingly

## Resources
- https://github.com/anishathalye/dotbot/wiki/Tips-and-Tricks#how-can-i-have-different-groups-of-tasks-for-different-hosts-with-different-configurations

# Credits
- [ThePrimeagen](https://github.com/ThePrimeagen) for tmux-sessionizer and neovim setup inspiration
