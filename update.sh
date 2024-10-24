#!/bin/sh
## https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5
set -e
pushd $HOME/.dotfiles &>/dev/null

force_flag=false

# Fetch the latest changes from the remote repository
git pull origin master --rebase --autostash || exit 1

# check if hardware-configuration.nix exist in system folder
if [ ! -f ./system/hardware-configuration.nix ]; then
  cp /etc/nixos/hardware-configuration.nix ./system/
  rm -rf .git 
fi

# Check for -f argument
while getopts 'f' flag; do
  case "${flag}" in
    f) force_flag=true ;;
    *) exit 1 ;;
  esac
done




# echo -e "\e[32m------ Autoformat nix files ------\e[0m"
# if command -v alejandra >/dev/null 2>&1; then
#     alejandra . &>/dev/null || (alejandra .; echo "Formatting failed!" && exit 1)
# else
#     echo "Error: alejandra command not found."
# fi
# echo -e "\e[32m------ git changes ------\e[0m"


echo -e "\e[32m------ Rebuild System Settings ------\e[0m"
sudo nixos-rebuild switch --flake .#nixos01 &>nixos-switch.log || (cat nixos-switch.log | grep --color error: && exit 1)
# Get current generation metadata
echo -e "\e[32m------ Rebuild User Settings ------\e[0m"
nix run home-manager/master -- switch --flake .#abayoumy &>>nixos-switch.log || (cat nixos-switch.log | grep --color error: && exit 1)
echo -e "\e[32m------ Operation Completed Successfully ------\e[0m"

# echo -e "\e[32m------ nixos Rebuild  ------\e[0m"
# sudo nixos-rebuild switch --flake . &>>nixos-switch.log || (cat nixos-switch.log | grep --color error: && exit 1)

# Back to where you were
popd &>/dev/null
