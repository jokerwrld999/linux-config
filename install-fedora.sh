#!/bin/bash


# >>>>> Global Variables
GITFOLDER=$(pwd)
DOTCONFIG=~/.config
SHARE=~/.local/share
PACKS="wget gh nano flameshot tldr google-chrome-stable discord telegram-desktop code latte-dock unzip gimp vim zip tree python-pip neofetch gparted google-chrome-stable easyeffects zsh"


echo -ne "
-------------------------------------------------------------------------
                    Updating System  
-------------------------------------------------------------------------
"
sudo dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
sudo dnf install -y fedora-workstation-repositories
sudo dnf config-manager --set-enabled google-chrome
sudo dnf update -y


echo -ne "
-------------------------------------------------------------------------
                    Copying Backup Data  
-------------------------------------------------------------------------
"
sudo chmod 777 $GITFOLDER
sudo chown -R $(whoami): $GITFOLDER
yes | sudo cp -ri $GITFOLDER/dotconfig/* $DOTCONFIG/
yes | sudo cp -ri $GITFOLDER/res/wallpapers  $SHARE/
yes | sudo cp -ri $GITFOLDER/res/fonts $SHARE/

# *** Reloading Font
fc-cache -vf


echo -ne "
-------------------------------------------------------------------------
                    Adding Vs Code Repository  
-------------------------------------------------------------------------
"
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf check-update

echo -ne "
-------------------------------------------------------------------------
                    Installing Essential Packages  
-------------------------------------------------------------------------
" 
sudo dnf install -y $PACKS


echo -ne "
-------------------------------------------------------------------------
                    Installing Snap Store  
-------------------------------------------------------------------------
" 
sudo dnf install -y snapd
sudo ln -s /var/lib/snapd/snap /snap
sudo snap install haruna --candidate


echo -ne "
-------------------------------------------------------------------------
                    Installing KDE Related Packages  
-------------------------------------------------------------------------
"
sudo dnf group install -y "KDE Plasma Workspaces" 


echo -ne "
-------------------------------------------------------------------------
                    KWin Scripts  
-------------------------------------------------------------------------
" 
# *** Force Blur
git clone https://github.com/esjeon/kwin-forceblur.git ~/Downloads/kwin-forceblur
cd ~/Downloads/kwin-forceblur/
sudo ./pack.sh
./install.sh

# *** Latte Windows
git clone https://github.com/psifidotos/kwinscript-window-colors.git ~/Downloads/kwinscript-window-colors
cd ~/Downloads/kwinscript-window-colors
plasmapkg2 -i .


echo -ne "
-------------------------------------------------------------------------
                    Installing Theme, Icons, Fonts, Cursors
                       Configure Kvantum Theme And SDDM  
-------------------------------------------------------------------------
" 
sudo dnf install -y gtk-murrine-engine sassc kvantum

# *** SDDM"
git clone https://github.com/icaho/Swish.git ~/Downloads/Swish
yes | sudo cp -ri ~/Downloads/Swish/ /usr/share/sddm/themes/
yes | sudo cp -ri $GITFOLDER/res/sddm/kde_settings.conf /etc/sddm.conf.d/

                
# *** Splash Screen
sudo tar -xzf $GITFOLDER/res/splash-screen/QuarksSplashDark.tar.gz -C $SHARE/plasma/look-and-feel/
yes | sudo cp -ri $GITFOLDER/res/splash-screen/ksplashrc $DOTCONFIG/


# *** Systray Latte Tweaks
git clone https://github.com/psifidotos/plasma-systray-latte-tweaks.git ~/Downloads/plasma-systray-latte-tweaks
cd ~/Downloads/plasma-systray-latte-tweaks/
yes | sudo cp -ri org.kde.plasma.systemtray org.kde.plasma.private.systemtray $SHARE/plasma/plasmoids/


# *** Orchis KDE"
git clone https://github.com/vinceliuice/Orchis-kde.git ~/Downloads/Orchis-kde
cd ~/Downloads/Orchis-kde/
./install.sh


# *** Orchis KDE Theme"
git clone https://github.com/vinceliuice/Orchis-theme.git ~/Downloads/Orchis-theme
cd ~/Downloads/Orchis-theme/
./install.sh


echo -ne "# *** Sevi Icon Theme"
git clone https://github.com/TaylanTatli/Sevi.git ~/Downloads/Sevi
cd ~/Downloads/Sevi/
./install.sh -black
/usr/libexec/plasma-changeicons Sevi-black


echo -ne "# *** Vimix Cursors"
git clone https://github.com/vinceliuice/Vimix-cursors.git ~/Downloads/Vimix-cursors
cd ~/Downloads/Vimix-cursors/
./install.sh -c


echo -ne "
-------------------------------------------------------------------------
                    Install Plasmoids  
-------------------------------------------------------------------------
" 
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


echo -ne "
-------------------------------------------------------------------------
                    Install Virtual Desktop Bar 
-------------------------------------------------------------------------
" 
git clone https://github.com/wsdfhjxc/virtual-desktop-bar.git ~/Downloads/virtual-desktop-bar
cd ~/Downloads/virtual-desktop-bar/
yes | sudo ./scripts/install-dependencies-fedora.sh
./scripts/install-applet.sh


echo -ne "
-------------------------------------------------------------------------
                    Install And Configure ZSH 
-------------------------------------------------------------------------
" 
# *** Auto-Suggestions Plugin
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting

# *** Copying Configs
touch "$HOME/.cache/zshhistory"
yes | cp -ri $GITFOLDER/res/zsh/.zshrc ~/
mkdir -p ~/.zsh
yes | cp -ri $GITFOLDER/res/zsh/aliasrc ~/.zsh/

# *** POWERLEVEL10K
git clone https://github.com/romkatv/powerlevel10k.git ~/.zsh//powerlevel10k


echo -ne "
-------------------------------------------------------------------------
                    Konsave Plasma Saver 
-------------------------------------------------------------------------
" 
sudo python -m pip install konsave
#konsave -i $GITFOLDER/res/konsave/JokerWrld-Theme.knsv
#konsave -a JokerWrld-Theme.knsv


echo -ne "
-------------------------------------------------------------------------
                    Cleaning Up The Downloads Folder 
-------------------------------------------------------------------------
"
cd
rm -rf ~/Downloads/*


# >>>>> Enabling Services and Graphical User Interface
chsh -s $(which zsh)

reboot
