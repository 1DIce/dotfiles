# Dotfiles

## Adding a new git submodule
add the submodule to the repository:
````
cd ~/dotfiles 
git submodule --depth 1 <repo-url> ./libs/<repo-name>
git config -f .gitmodules submodule.path/to/submodule.shallow true
git config -f .gitmodules submodule.path/to/submodule.ignore dirty

``````
modify the install.conf.yml accordingly

