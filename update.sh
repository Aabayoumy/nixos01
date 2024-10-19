clear
echo -e "\e[32m------ Autoformat nix files ------\e[0m"
alejandra . &>/dev/null  || ( alejandra . ; echo "formatting failed!" && exit 1)
echo -e "\e[32m------ Rebuild System Settings ------\e[0m"
sudo nixos-rebuild switch --flake /media/data/nixos01#nixos01
echo -e "\e[32m------ Rebuild User Settings ------\e[0m"
nix run home-manager/master -- switch --flake /media/data/nixos01#abayoumy