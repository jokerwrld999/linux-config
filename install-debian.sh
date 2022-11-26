#!/bin/bash


# >>>>> Global Variables
GITFOLDER=$(pwd)
DOWNLOADS=~/Downloads
DOTCONFIG=~/.config
SHARE=~/.local/share
PACKS="wget gh nano flameshot remmina tldr telegram-desktop code latte-dock unzip gimp vim zip tree python3-pip neofetch gparted easyeffects zsh"


echo -ne "
-------------------------------------------------------------------------
                    Updating System  
-------------------------------------------------------------------------
"
sudo apt install -y nala
sudo nala update && sudo nala upgrade -y


echo -ne "
-------------------------------------------------------------------------
                    Copying Backup Data  
-------------------------------------------------------------------------
"
sudo chmod -R 755 $GITFOLDER
sudo chown -R $USER:$USER $GITFOLDER
yes | sudo cp -ri $GITFOLDER/dotconfig/* $DOTCONFIG/
yes | sudo cp -ri $GITFOLDER/resources/wallpapers  $SHARE/
yes | sudo cp -ri $GITFOLDER/resources/fonts $SHARE/

# *** Reloading Font
fc-cache -vf


echo -ne "
-------------------------------------------------------------------------
                    Adding Chrome To The Repository  
-------------------------------------------------------------------------
"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P $DOWNLOADS/
sudo apt install -y $DOWNLOADS/google-chrome-stable_current_amd64.deb


echo -ne "
-------------------------------------------------------------------------
                    Adding Vs Code Repository  
-------------------------------------------------------------------------
"
sudo apt-get install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg

echo -ne "
-------------------------------------------------------------------------
                    Installing Essential Packages  
-------------------------------------------------------------------------
" 
sudo nala install -y apt-transport-https
sudo nala update -y
sudo nala install -y $PACKS


echo -ne "
-------------------------------------------------------------------------
                    Installing Snaps  
-------------------------------------------------------------------------
" 
sudo nala install -y snapd
sudo snap install core
sudo snap install haruna --candidate
sudo snap install discord



echo -ne "
-------------------------------------------------------------------------
                    Installing KDE Related Packages  
-------------------------------------------------------------------------
"
sudo nala install -y kde-standard 


echo -ne "
-------------------------------------------------------------------------
                    KWin Scripts  
-------------------------------------------------------------------------
" 
# *** Force Blur
git clone https://github.com/esjeon/kwin-forceblur.git $DOWNLOADS/kwin-forceblur
cd $DOWNLOADS/kwin-forceblur/
sudo ./pack.sh
./install.sh

# *** Latte Windows
git clone https://github.com/psifidotos/kwinscript-window-colors.git $DOWNLOADS/kwinscript-window-colors
cd $DOWNLOADS/kwinscript-window-colors
plasmapkg2 -i .


echo -ne "
-------------------------------------------------------------------------
                    Installing Theme, Icons, Fonts, Cursors
                       Configure Kvantum Theme And SDDM  
-------------------------------------------------------------------------
" 
sudo nala install -y gtk2-engines-murrine sassc qt5-style-kvantum qt5-style-kvantum-themes

# *** SDDM"
systemctl disable gdm
systemctl enable sddm
mkdir -p /etc/sddm.conf.d
git clone https://github.com/icaho/Swish.git $DOWNLOADS/Swish
yes | sudo cp -ri $DOWNLOADS/Swish/ /usr/share/sddm/themes/
yes | sudo cp -ri $GITFOLDER/resources/sddm/kde_settings.conf /etc/sddm.conf.d/

                
# *** Splash Screen
plasmapkg2 -i $GITFOLDER/resources/splash-screen/watch-dogs-splash.plasmoid
yes | sudo cp -ri $GITFOLDER/resources/splash-screen/ksplashrc $DOTCONFIG/


# *** Systray Latte Tweaks
git clone https://github.com/psifidotos/plasma-systray-latte-tweaks.git $DOWNLOADS/plasma-systray-latte-tweaks
cd $DOWNLOADS/plasma-systray-latte-tweaks/
mkdir -p $SHARE/plasma/plasmoids/
yes | sudo cp -ri org.kde.plasma.systemtray org.kde.plasma.private.systemtray $SHARE/plasma/plasmoids/


# *** Orchis KDE"
git clone https://github.com/vinceliuice/Orchis-kde.git $DOWNLOADS/Orchis-kde
cd $DOWNLOADS/Orchis-kde/
./install.sh


# *** Orchis KDE Theme"
git clone https://github.com/vinceliuice/Orchis-theme.git $DOWNLOADS/Orchis-theme
cd $DOWNLOADS/Orchis-theme/
./install.sh -t purple --tweaks black


# *** Sevi Icon Theme
git clone https://github.com/TaylanTatli/Sevi.git $DOWNLOADS/Sevi
cd $DOWNLOADS/Sevi/
./install.sh -black
/usr/libexec/plasma-changeicons Sevi-black


# *** Bibata Cursors
tar -xvf $GITFOLDER/resources/cursors/Bibata.tar.gz --directory $DOWNLOADS
mv $DOWNLOADS/Bibata-* ~/.icons/
sudo mv Bibata-* /usr/share/icons/


echo -ne "
-------------------------------------------------------------------------
                    Install Plasmoids  
-------------------------------------------------------------------------
" 
# *** Plasma Customization Saver
git clone https://github.com/paju1986/PlasmaConfSaver.git $DOWNLOADS/PlasmaConfSaver
cd $DOWNLOADS/PlasmaConfSaver/com.pajuelo.plasmaConfSaver/
plasmapkg2 -i .

# *** Latte Spacer
git clone https://github.com/psifidotos/applet-latte-spacer.git $DOWNLOADS/applet-latte-spacer
cd $DOWNLOADS/applet-latte-spacer/
plasmapkg2 -i .

# *** Latte Separator
git clone https://github.com/psifidotos/applet-latte-separator.git $DOWNLOADS/applet-latte-separator
cd $DOWNLOADS/applet-latte-separator/
plasmapkg2 -i .

# *** Ditto Menu
git clone https://github.com/adhec/dittoMenuKDE.git $DOWNLOADS/dittoMenuKDE
cd $DOWNLOADS/dittoMenuKDE/package/
plasmapkg2 -i .

# *** Shutdown Switch
git clone https://github.com/Davide-sd/shutdown_or_switch.git $DOWNLOADS/shutdown_or_switch
cd $DOWNLOADS/shutdown_or_switch/plasmoid/
plasmapkg2 -i .


echo -ne "
-------------------------------------------------------------------------
                    Install Virtual Desktop Bar 
-------------------------------------------------------------------------
" 
git clone https://github.com/wsdfhjxc/virtual-desktop-bar.git $DOWNLOADS/virtual-desktop-bar
cd $DOWNLOADS/virtual-desktop-bar/
yes | sudo ./scripts/install-dependencies-ubuntu.sh
./scripts/install-applet.sh


echo -ne "
-------------------------------------------------------------------------
                    Install And Configure ZSH 
-------------------------------------------------------------------------
" 
# *** Auto-Suggestions Plugin
sudo nala install -y autojump
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

# *** Copying Configs
touch "$HOME/.cache/zshhistory"
yes | cp -ri $GITFOLDER/resources/zsh/.zshrc ~/
mkdir -p ~/.zsh
yes | cp -ri $GITFOLDER/resources/zsh/aliasrc ~/.zsh/

# *** POWERLEVEL10K
git clone https://github.com/romkatv/powerlevel10k.git ~/.zsh//powerlevel10k


echo -ne "
-------------------------------------------------------------------------
                    Konsave Plasma Saver 
-------------------------------------------------------------------------
" 
sudo python -m pip install konsave
#konsave -i $GITFOLDER/resources/konsave/JokerWrld-Theme.knsv
#konsave -a JokerWrld-Theme.knsv


echo -ne "
-------------------------------------------------------------------------
                    Cleaning Up The Downloads Folder 
-------------------------------------------------------------------------
"
sudo chmod -R 755 $DOTCONFIG $SHARE
sudo chown -R $USER:$USER $DOTCONFIG $SHARE
cd
rm -rf $DOWNLOADS/*
sudo apt-get autoclean && sudo apt-get autoremove


# >>>>> Enabling Services and Graphical User Interface
chsh -s $(which zsh)

sudo reboot
