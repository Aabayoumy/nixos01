#!/bin/sh
## https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5
set -e
pushd /media/data/nixos01 &>/dev/null

force_flag=false

# check if hardware-configuration.nix exist in system folder
if [ ! -f ./system/hardware-configuration.nix ]; then
  cp /etc/nixos/hardware-configuration.nix ./system/
  exit 1
fi

# Check for -f argument
while getopts 'f' flag; do
  case "${flag}" in
    f) force_flag=true ;;
    *) exit 1 ;;
  esac
done

if git diff --quiet '*.*'; then
    if [ "$force_flag" = true ]; then
        echo "No changes detected, but -f flag is set. Proceeding..."
    else
        echo "No changes detected, exiting."
        popd &>/dev/null
        exit 0
    fi
fi

echo -e "\e[32m------ Autoformat nix files ------\e[0m"
alejandra . &>/dev/null  || ( alejandra . ; echo "formatting failed!" && exit 1)
git add .
# echo -e "\e[32m------ git changes ------\e[0m"
# # Shows your changes
# git diff -U0 '*.nix'
echo -e "\e[32m------ Rebuild System Settings ------\e[0m"
sudo nixos-rebuild switch --flake /media/data/nixos01#nixos01 &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)
# Get current generation metadata
current=$(nixos-rebuild list-generations | grep current)
echo -e "\e[32m------ Rebuild User Settings ------\e[0m"
nix run home-manager/master -- switch --flake /media/data/nixos01#abayoumy &>>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1)
echo -e "\e[32m------ Operation Completed Successfully ------\e[0m"

# Commit all changes witih the generation metadata
git add .
git commit -am "$current"

# Back to where you were
popd &>/dev/null
