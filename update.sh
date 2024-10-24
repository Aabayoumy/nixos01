#!/bin/sh
## https://gist.github.com/0atman/1a5133b842f929ba4c1e195ee67599d5
set -e
pushd $HOME/.dotfiles &>/dev/null

force_flag=false

# Check if the current folder is a Git repository
if [ -d .git ]; then
# Fetch the latest changes from the remote repository
git pull origin master --rebase --autostash || exit 1
fi

# check if hardware-configuration.nix exist in system folder
if [ ! -f ./system/hardware-configuration.nix ]; then
  cp /etc/nixos/hardware-configuration.nix ./system/
  git add .  
fi



if command -v alejandra >/dev/null 2>&1; then
  echo -e "\e[32m------ Autoformat nix files ------\e[0m"
    alejandra . &>/dev/null || (alejandra .; echo "Formatting failed!" && exit 1)
else
    echo "Error: alejandra command not found."
fi

# Check if home-manager is installed, and install it if it is not
if ! command -v home-manager &>/dev/null; then
  echo -e "\e[32m------ Installing Home Manager ------\e[0m"
  nix-channel --add nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz home-manager home-manager
  nix-channel --update
  nix-shell '<home-manager>' -A install
fi
# Initialize flags
system_rebuild=false
user_rebuild=false

# Parse command-line options
while getopts ":hsu" opt; do
  case ${opt} in
    h )
      echo "Usage:"
      echo "-h     Display this help message."
      echo "-s     Run system rebuild."
      echo "-u     Run user rebuild."
      exit 0
      ;;
    s )
      system_rebuild=true
      ;;
    u )
      user_rebuild=true
      ;;
    \? )
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    : )
      echo "Invalid option: -$OPTARG requires an argument" >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

# Your current logic to handle rebuilds
if [ "$system_rebuild" = true ]; then
  echo -e "\e[32m------ Rebuild System Settings ------\e[0m"
  sudo nixos-rebuild switch --flake .#nixos01 --impure &>nixos-switch.log || (cat nixos-switch.log | grep --color error: && exit 1)
  echo -e "\e[32m------ System rebuild completed successfully ------\e[0m"
  exit 0
fi

if [ "$user_rebuild" = true ]; then
  echo -e "\e[32m------ Rebuild User Settings ------\e[0m"
  nix run home-manager/master -- switch --flake .#abayoumy &>>nixos-switch.log || (cat nixos-switch.log | grep --color error: && exit 1)
  echo -e "\e[32m------ User rebuild completed successfully ------\e[0m"
  exit 0
fi

# echo -e "\e[32m------ nixos Rebuild  ------\e[0m"
# sudo nixos-rebuild switch --flake . &>>nixos-switch.log || (cat nixos-switch.log | grep --color error: && exit 1)

# Back to where you were
popd &>/dev/null
