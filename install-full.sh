#!/bin/bash

# ****  Global Variables
GITFOLDER=$(pwd)
DOWNLOADS=~/Downloads
DOTCONFIG=~/.config
SHARE=~/.local/share

echo -ne "
-------------------------------------------------------------------------
                    Updating System
               Installing Essential Packages 
-------------------------------------------------------------------------
"
if [[ -x "$(command -v apt)" ]]
then
   PACKS="wget gh nano flameshot remmina tldr telegram-desktop 
   latte-dock unzip gimp zip tree python3-pip neofetch gparted easyeffects zsh"
   
   sudo apt install -y nala
   sudo nala install -y apt-transport-https
   sudo nala update && sudo nala upgrade -y
   
   sudo nala install -y $PACKS
elif [[ -x "$(command -v dnf)" ]]
then
   PACKS="wget gh nano flameshot remmina tldr telegram-desktop 
   latte-dock unzip gimp zip tree python3-pip neofetch gparted easyeffects zsh"
   
   sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
   sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
   sudo dnf install -y fedora-workstation-repositories
   # *** Installing Chrome
   sudo dnf config-manager --set-enabled google-chrome
   sudo dnf update -y
   sudo dnf install -y $PACKS
elif [[ -x "$(command -v pacman)" ]]
then
   PACKS="wget github-cli nano flameshot remmina tldr telegram-desktop 
   latte-dock unzip gimp zip tree python-pip neofetch gparted easyeffects zsh"

   sudo pacman -Suy --noconfirm
   sudo pacman --noconfirm -S $PACKS
   
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
                    Copying Needed Data  
-------------------------------------------------------------------------
"
sudo chmod -R 755 $GITFOLDER
sudo chown -R $USER:$USER $GITFOLDER
yes | sudo cp -ri $GITFOLDER/dotconfig/* $DOTCONFIG/
yes | sudo cp -ri $GITFOLDER/resources/fonts $SHARE/

# **** Reloading Font
fc-cache -vf

echo -ne "
-------------------------------------------------------------------------
                    Installing VPN Packages  
-------------------------------------------------------------------------
"
if [[ -x "$(command -v nala)" ]]
then
   sudo nala install -y strongswan network-manager-strongswan libcharon-extra-plugins
elif [[ -x "$(command -v dnf)" ]]
then
    # *** Installing Chrome
   sudo dnf config-manager --set-enabled google-chrome
   sudo dnf update -y
   sudo dnf install -y google-chrome
elif [[ -x "$(command -v pacman)" ]]
then
   sudo pacman --noconfirm -S strongswan networkmanager-strongswan
else
   echo "FAILED TO INSTALL Chrome!"
fi

echo -ne "
-------------------------------------------------------------------------
                    Installing Chrome  
-------------------------------------------------------------------------
"
if [[ -x "$(command -v nala)" ]]
then
   wget -nv https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P $DOWNLOADS/
   sudo nala install -y $DOWNLOADS/google-chrome-stable_current_amd64.deb
elif [[ -x "$(command -v dnf)" ]]
then
    # *** Installing Chrome
   sudo dnf config-manager --set-enabled google-chrome
   sudo dnf update -y
   sudo dnf install -y google-chrome
elif [[ -x "$(command -v yay)" ]]
then
   # *** Installing Chrome | AUR
   yay --noprovides --answerdiff None --answerclean None --noconfirm -S google-chrome
else
   echo "FAILED TO INSTALL Chrome!"
fi

echo -ne "
-------------------------------------------------------------------------
                    Installing Vs Code  
-------------------------------------------------------------------------
"
if [[ -x "$(command -v nala)" ]]
then
   wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
   sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
   sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
   suod rm -rf packages.microsoft.gpg
   sudo nala install -y code
elif [[ -x "$(command -v dnf)" ]]
then
   sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
   sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
   sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
   sudo dnf install -y code
elif [[ -x "$(command -v yay)" ]]
then
   # *** Installing VS Code | AUR
   yay --noprovides --answerdiff None --answerclean None --noconfirm -S visual-studio-code-bin
else
   echo "FAILED TO INSTALL Code!"
fi

echo -ne "
-------------------------------------------------------------------------
                    Installing Snap Store
-------------------------------------------------------------------------
"
if [[ -x "$(command -v nala)" ]]
then
   sudo nala install -y snapd
elif [[ -x "$(command -v dnf)" ]]
then
   sudo dnf install snapd
   sudo ln -s /var/lib/snapd/snap /snap
elif [[ -x "$(command -v yay)" ]]
then
   # *** Installing Snap | AUR
   yay --noprovides --answerdiff None --answerclean None --noconfirm -S snapd
   sudo systemctl enable --now snapd.socket
else
   echo "FAILED TO INSTALL Snap Store!"
fi

echo -ne "
-------------------------------------------------------------------------
                    Installing Quickemu
-------------------------------------------------------------------------
"
if [[ -x "$(command -v nala)" ]]
then
   sudo nala install -y snapd
elif [[ -x "$(command -v dnf)" ]]
then
   sudo dnf install snapd
   sudo ln -s /var/lib/snapd/snap /snap
else
   echo "FAILED TO INSTALL Snap Store!"
fi

echo -ne "
-------------------------------------------------------------------------
                    Installing Snap Packages
-------------------------------------------------------------------------
"
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install core
sudo snap install discord

echo -ne "
-------------------------------------------------------------------------
                    Installing KDE Related Packages  
-------------------------------------------------------------------------
"
if [[ -x "$(command -v nala)" ]]
then
   sudo nala install -y kde-standard
elif [[ -x "$(command -v dnf)" ]]
then
   sudo dnf group install -y "KDE Plasma Workspaces"
elif [[ -x "$(command -v pacman)" ]]
then
   sudo pacman --noconfirm -S  xorg plasma plasma-wayland-session kde-applications
   sudo systemctl enable sddm
   sudo systemctl enable NetworkManager
else
   echo "FAILED TO INSTALL KDE!"
fi

echo -ne "
-------------------------------------------------------------------------
                    Installing KWin Scripts  
-------------------------------------------------------------------------
" 
# **** Force Blur
git clone https://github.com/esjeon/kwin-forceblur.git $DOWNLOADS/kwin-forceblur
cd $DOWNLOADS/kwin-forceblur/
./pack.sh
./install.sh

# *** Enable Script Configuration
 mkdir -p $SHARE/kservices5/
 yes | cp -ri $SHARE/kwin/scripts/forceblur/metadata.desktop $SHARE/kservices5/forceblur.desktop

# **** Latte Windows
git clone https://github.com/psifidotos/kwinscript-window-colors.git $DOWNLOADS/kwinscript-window-colors
cd $DOWNLOADS/kwinscript-window-colors
plasmapkg2 -i .

echo -ne "
-------------------------------------------------------------------------
                    Installing Theme, Icons, Fonts, Cursors
                       Configuring Kvantum Theme And SDDM  
-------------------------------------------------------------------------
"
if [[ -x "$(command -v nala)" ]]
then
   sudo nala install -y gtk2-engines-murrine sassc qt5-style-kvantum qt5-style-kvantum-themes
elif [[ -x "$(command -v dnf)" ]]
then
   sudo dnf install -y gtk-murrine-engine sassc kvantum
elif [[ -x "$(command -v pacman)" ]]
then
   sudo pacman --noconfirm -S  gtk-engine-murrine sassc kvantum-qt5
else
   echo "FAILED TO INSTALL Theme Packages!"
fi

# **** SDDM
sudo systemctl disable gdm
sudo systemctl enable sddm
sudo mkdir -p /etc/sddm.conf.d
git clone https://github.com/icaho/Swish.git $DOWNLOADS/Swish
yes | sudo cp -ri $DOWNLOADS/Swish/ /usr/share/sddm/themes/
yes | sudo cp -ri $GITFOLDER/resources/sddm/kde_settings.conf /etc/sddm.conf.d/
sudo chown -R sddm:sddm /var/lib/sddm/.config  
            
# **** Splash Screen
plasmapkg2 -i $GITFOLDER/resources/splash-screen/watch-dogs-splash.plasmoid
yes | sudo cp -ri $GITFOLDER/resources/splash-screen/ksplashrc $DOTCONFIG/

# **** Systray Latte Tweaks
git clone https://github.com/psifidotos/plasma-systray-latte-tweaks.git $DOWNLOADS/plasma-systray-latte-tweaks
cd $DOWNLOADS/plasma-systray-latte-tweaks/
mkdir -p $SHARE/plasma/plasmoids/
yes | sudo cp -ri org.kde.plasma.systemtray org.kde.plasma.private.systemtray $SHARE/plasma/plasmoids/

# **** Orchis KDE
git clone https://github.com/vinceliuice/Orchis-kde.git $DOWNLOADS/Orchis-kde
cd $DOWNLOADS/Orchis-kde/
sudo ./install.sh

# **** Orchis KDE Theme
git clone https://github.com/vinceliuice/Orchis-theme.git $DOWNLOADS/Orchis-theme
cd $DOWNLOADS/Orchis-theme/
sudo ./install.sh -t purple --tweaks black

# **** Sevi Icon Theme
git clone https://github.com/TaylanTatli/Sevi.git $DOWNLOADS/Sevi
cd $DOWNLOADS/Sevi/
./install.sh -black
changeicons=$(find /usr/lib/ -name "plasma-changeicons")
$changeicons Sevi-black

# **** Bibata Cursors
tar -xvf $GITFOLDER/resources/cursors/Bibata-*.tar.gz --directory $DOWNLOADS
yes | sudo cp -ri $DOWNLOADS/Bibata-* ~/.icons/
yes | sudo cp -ri $DOWNLOADS/Bibata-* /usr/share/icons/

echo -ne "
-------------------------------------------------------------------------
                    Installing Plasmoids  
-------------------------------------------------------------------------
" 
# **** Plasma Customization Saver
git clone https://github.com/paju1986/PlasmaConfSaver.git $DOWNLOADS/PlasmaConfSaver
cd $DOWNLOADS/PlasmaConfSaver/com.pajuelo.plasmaConfSaver/
plasmapkg2 -i .

# **** Latte Spacer
git clone https://github.com/psifidotos/applet-latte-spacer.git $DOWNLOADS/applet-latte-spacer
cd $DOWNLOADS/applet-latte-spacer/
plasmapkg2 -i .

# **** Latte Separator
git clone https://github.com/psifidotos/applet-latte-separator.git $DOWNLOADS/applet-latte-separator
cd $DOWNLOADS/applet-latte-separator/
plasmapkg2 -i .

# **** Shutdown Switch
git clone https://github.com/Davide-sd/shutdown_or_switch.git $DOWNLOADS/shutdown_or_switch
cd $DOWNLOADS/shutdown_or_switch/plasmoid/
plasmapkg2 -i .

echo -ne "
-------------------------------------------------------------------------
                    Installing Virtual Desktop Bar 
-------------------------------------------------------------------------
" 
git clone https://github.com/wsdfhjxc/virtual-desktop-bar.git $DOWNLOADS/virtual-desktop-bar
cd $DOWNLOADS/virtual-desktop-bar/
 
if [[ -x "$(command -v nala)" ]]
then
   yes | sudo ./scripts/install-dependencies-ubuntu.sh
elif [[ -x "$(command -v dnf)" ]]
then
   yes | sudo ./scripts/install-dependencies-fedora.sh
elif [[ -x "$(command -v pacman)" ]]
then
   yes | sudo ./scripts/install-dependencies-arch.sh
else
   echo "FAILED TO INSTALL Desktop Bar!"
fi
./scripts/install-applet.sh

echo -ne "
-------------------------------------------------------------------------
                    Installing And Configuring ZSH 
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
   yay --noprovides --answerdiff None --answerclean None --noconfirm -S autojump
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
sudo chmod -R 755 $DOTCONFIG $SHARE
sudo chown -R $USER:$USER $DOTCONFIG $SHARE
cd && sudo rm -rf $DOWNLOADS/*

if [[ -x "$(command -v apt)" ]]
then
   sudo apt autoclean && sudo apt autoremove
elif [[ -x "$(command -v dnf)" ]]
then
   sudo dnf clean all
elif [[ -x "$(command -v pacman)" ]]
then
   sudo pacman -Scc --noconfirm
   sudo pacman -Rns --noconfirm $(pacman -Qtdq)
else
   echo "FAILED TO INSTALL Chrome!"
fi
sudo rm -rf ~/.cache/*

echo -ne "
-------------------------------------------------------------------------
                    Installing Grub Theme 
-------------------------------------------------------------------------
"
sleep 5
sudo $GITFOLDER/resources/grub-themes/install.sh


echo -ne "
-------------------------------------------------------------------------
                    Changing Shell To ZSH 
-------------------------------------------------------------------------
"
sudo chsh -s $(command -v zsh) $USER

echo -ne "
-------------------------------------------------------------------------
                    Rebooting 
-------------------------------------------------------------------------
"
#sudo reboot