#!/bin/bash

# ****  Global Variables
GITFOLDER=$(pwd)
PACKS="zsh"

echo -ne "
-------------------------------------------------------------------------
                    Updating System
               Installing Essential Packages 
-------------------------------------------------------------------------
"
if [[ -x "$(command -v apt)" ]]
then
   sudo apt install -y nala
   sudo nala install -y apt-transport-https
   sudo nala update && sudo nala upgrade -y
   sudo nala install -y $PACKS
elif [[ -x "$(command -v dnf)" ]]
then
   sudo dnf update -y
   sudo dnf install -y $PACKS
elif [[ -x "$(command -v pacman)" ]]
then
   sudo pacman -Syyu --noconfirm
   sudo pacman -S --noconfirm --needed base-devel $PACKS

   # *** Installing Yay AUR Helper
   sudo git clone https://aur.archlinux.org/yay-git.git /opt/yay-git
   sudo chown -R $(whoami): /opt/yay-git
   cd /opt/yay-git/
   yes | makepkg -si
else
   echo "FAILED TO INSTALL PACKAGE: Package manager not found. You must manually install: $PACKS">&2;
fi

echo -ne "
-------------------------------------------------------------------------
                    Install And Configure ZSH 
-------------------------------------------------------------------------
" 
# **** Auto-Suggestions Plugin
mkdir -p ~/.zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
# **** POWERLEVEL10K
git clone https://github.com/romkatv/powerlevel10k.git ~/.zsh//powerlevel10k

if [[ -x "$(command -v nala)" ]]
then
   sudo nala install -y autojump
elif [[ -x "$(command -v dnf)" ]]
then
   sudo dnf install -y autojump
elif [[ -x "$(command -v yay)" ]]
then
   # *** Auto-Jump Plugin | AUR
   yes | yay -S autojump
else
   echo "FAILED TO INSTALL ZSH Packages!"
fi

# **** Copying Configs
touch "$HOME/.cache/zshhistory"
yes | cp -ri $GITFOLDER/resources/zsh/.zshrc ~/
yes | cp -ri $GITFOLDER/resources/zsh/aliasrc ~/.zsh/
yes | cp -ri $GITFOLDER/resources/zsh/.p10k.zsh ~/.zsh/

echo -ne "
-------------------------------------------------------------------------
                    Cleaning Up Temporary Files 
-------------------------------------------------------------------------
"
cd && rm -rf $DOWNLOADS/*

if [[ -x "$(command -v apt)" ]]
then
   sudo apt autoclean && sudo apt autoremove
elif [[ -x "$(command -v dnf)" ]]
then
   sudo dnf clean all
elif [[ -x "$(command -v pacman)" ]]
then
   sudo pacman -Scc
   sudo pacman -Rns $(pacman -Qtdq)
else
   echo "FAILED TO INSTALL Chrome!"
fi
sudo rm -rf ~/.cache/*

echo -ne "
-------------------------------------------------------------------------
                    Changing Shell To ZSH 
-------------------------------------------------------------------------
"
sudo chsh -s $(which $1) $USER

echo -ne "
-------------------------------------------------------------------------
                    Rebooting 
-------------------------------------------------------------------------
"
sudo reboot