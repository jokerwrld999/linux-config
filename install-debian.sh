#!/bin/bash

# >>>>> Global Variables
GITFOLDER=~/Desktop/linux-automate
DOTCONFIG=~/.config
SHARE=~/.local/share


# >>>>> Updating System && Installing apt
#echo "deb https://deb.volian.org/volian/ scar main" | tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list
#wget -qO - https://deb.volian.org/volian/scar.key | tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg > /dev/null
sudo apt update


# >>>>> Copying Backup Data
sudo cp -r $GITFOLDER/dotconfig/* $DOTCONFIG/
sudo cp -r $GITFOLDER/res/wallpapers  $SHARE/
sudo cp -r $GITFOLDER/res/fonts $SHARE/
sudo chown -R $(whoami): $DOTCONFIG/ $SHARE/

# *** Reloading Font
fc-cache -vf


# >>>>> Installing Essential Programs 
yes | sudo apt install wget git flameshot unzip gimp vim zip tree python-pip neofetch gparted zsh

# *** Installing VS Code
yes | apt install software-properties-common apt-transport-https
wget -O- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee $SHARE/keyrings/vscode.gpg
echo deb [arch=amd64 signed-by=$SHARE/keyrings/vscode.gpg] https://packages.microsoft.com/repos/vscode stable main | tee /etc/apt/sources.list.d/vscode.list
yes | sudo apt install code

# *** Installing Chrome on Debian
cd ~/Downloads/
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
yes | sudo apt install ./google-chrome-stable_current_amd64.deb


# Customizing KDE Plasma
# >>>>> Installing KWin Scripts
# *** Force Blur
git clone https://github.com/esjeon/kwin-forceblur.git ~/Downloads/kwin-forceblur
cd ~/Downloads/kwin-forceblur/
sudo ./pack.sh
./install.sh

# *** Latte Windows
git clone https://github.com/psifidotos/kwinscript-window-colors.git ~/Downloads/kwinscript-window-colors
cd ~/Downloads/kwinscript-window-colors
plasmapkg2 -i .


# >>>>> Installing Theme, Icons, Fonts, Cursors // Configure Kvantum Theme && SDDM
yes | sudo apt install gtk-engine-murrine sassc kvantum

# *** SDDM
git clone https://github.com/icaho/Swish.git ~/Downloads/Swish
yes | sudo cp -r ~/Downloads/Swish/ /usr/share/sddm/themes/
sudo sed -i 's/Current=.*/Current=Swish/' /etc/sddm.conf.d/kde_settings.conf

# *** Splash Screen
sudo tar -xzf $GITFOLDER/res/splash-screen/QuarksSplashDark.tar.gz -C $SHARE/plasma/look-and-feel/
sudo sed -i 's/Theme=.*/Theme=QuarksSplashDark/' $DOTCONFIG/ksplashrc


# *** Systray Latte Tweaks
git clone https://github.com/psifidotos/plasma-systray-latte-tweaks.git ~/Downloads/plasma-systray-latte-tweaks
cd ~/Downloads/plasma-systray-latte-tweaks/
sudo cp -r org.kde.plasma.systemtray org.kde.plasma.private.systemtray $SHARE/plasma/plasmoids/

# *** Orchis KDE
git clone https://github.com/vinceliuice/Orchis-kde.git ~/Downloads/Orchis-kde
cd ~/Downloads/Orchis-kde/
./install.sh

# *** Orchis KDE Theme
git clone https://github.com/vinceliuice/Orchis-theme.git ~/Downloads/Orchis-theme
cd ~/Downloads/Orchis-theme/
./install.sh

# *** Tela Icon Theme
git clone https://github.com/PlagaMedicum/PlagueSur-icon-theme.git ~/.local/share/icons/PlagueSur
/usr/lib/plasma-changeicons PlagueSur

# *** Vimix Cursors
git clone https://github.com/vinceliuice/Vimix-cursors.git ~/Downloads/Vimix-cursors
cd ~/Downloads/Vimix-cursors/
./install.sh


# >>>>> Install Plasmoids
# *** Plasma Customization Saver
git clone https://github.com/paju1986/PlasmaConfSaver.git ~/Downloads/PlasmaConfSaver
cd ~/Downloads/PlasmaConfSaver/com.pajuelo.plasmaConfSaver/
plasmapkg2 -i .

# *** Latte Spacer
git clone https://github.com/psifidotos/applet-latte-spacer.git ~/Downloads/applet-latte-spacer
cd ~/Downloads/applet-latte-spacer/
plasmapkg2 -i .

# *** Latte Separator
git clone https://github.com/psifidotos/applet-latte-separator.git ~/Downloads/applet-latte-separator
cd ~/Downloads/applet-latte-separator/
plasmapkg2 -i .

# *** Ditto Menu
git clone https://github.com/adhec/dittoMenuKDE.git ~/Downloads/dittoMenuKDE
cd ~/Downloads/dittoMenuKDE/package/
plasmapkg2 -i .

# *** Shutdown Switch
git clone https://github.com/Davide-sd/shutdown_or_switch.git ~/Downloads/shutdown_or_switch
cd ~/Downloads/shutdown_or_switch/plasmoid/
plasmapkg2 -i .

## >>>>> Install Virtual Desktop Bar
git clone https://github.com/wsdfhjxc/virtual-desktop-bar.git ~/Downloads/virtual-desktop-bar
cd ~/Downloads/virtual-desktop-bar/
./scripts/install-dependencies-ubuntu.sh
./scripts/install-applet.sh

# >>>>> Install && Configure Latte-Dock
yes | sudo apt install latte-dock


# >>>>> Install And Configure ZSH
# *** Auto-Suggestions Plugin
yes | apt install zsh-autosuggestions

# *** Auto-Highlighting Plugin
yes | apt install zsh-syntax-highlighting

# *** Auto-Jump Plugin
yes | apt install autojump

# *** Copying Configs
touch "$HOME/.cache/zshhistory"
cp -r $GITFOLDER/res/zsh/.zshrc ~/
mkdir -p ~/zsh
cp -r $GITFOLDER/res/zsh/aliasrc ~/zsh/

# *** POWERLEVEL10K
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>! ~/.zshrc
#p10k configure


# >>>>> Konsave Plasma Saver
sudo python -m pip install konsave
konsave -i $GITFOLDER/res/konsave/Ultimate-Theme.knsv
konsave -a Ultimate-Theme.knsv


# >>>>> Cleaning Up The Downloads Folder
cd ~
rm -rf ~/Downloads/*