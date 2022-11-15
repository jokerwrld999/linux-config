#!/bin/bash

# >>>>> Global Variables
GITFOLDER=~/Desktop/linux-automate
DOTCONFIG=~/.config
SHARE=~/.local/share


# >>>>> Updating System
sudo pacman -Syyu --noconfirm


# >>>>> Copying Backup Data
sudo cp -r $GITFOLDER/dotconfig/* $DOTCONFIG/
sudo cp -r $GITFOLDER/res/wallpapers  $SHARE/
sudo cp -r $GITFOLDER/res/fonts $SHARE/
sudo chown -R $(whoami): $DOTCONFIG/ $SHARE/

# *** Reloading Font
fc-cache -vf


# >>>>> Installing Essential Programs 
sudo pacman -S --noconfirm --needed base-devel wget unzip gimp vim flameshot neofetch zip python-pip tree gparted


# >>>>> Installing Yay AUR Helper
sudo git clone https://aur.archlinux.org/yay-git.git /opt/yay-git
sudo chown -R $(whoami): /opt/yay-git
cd /opt/yay-git/
yes | makepkg -si

# *** Installing Kotatogram | AUR
yes | yay -S kotatogram-desktop-bin

# *** Installing VS Code | AUR
yes | yay -S visual-studio-code-bin

# *** Installing Chrome | AUR
yes | yay -S google-chrome

# *** Installing Plusle Effects | AUR
yes | yay -S pulseeffects-legacy
pulseeffects -l Ultimate-Sound

# *** Install Keyring
yes | yay -S qtkeychain gnome-keyring

# >>>>> Installing Snapd
git clone https://aur.archlinux.org/snapd.git ~/Downloads/snapd
cd ~/Downloads/snapd/
yes | makepkg -si 
sudo systemctl enable --now snapd.socket
sudo ln -s /var/lib/snapd/snap /snap


# Customizing KDE
# >>>>> Installing KDE Plasma
#sudo pacman -S --noconfirm plasma-meta kde-applications-meta


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
 

# >>>>> Installing Theme, Icons, Fonts, Cursors // Configure Kvantum Theme And SDDM
sudo pacman -S --noconfirm gtk-engine-murrine sassc kvantum-qt5

# *** SDDM
git clone https://github.com/icaho/Swish.git ~/Downloads/Swish
yes | sudo cp -r ~/Downloads/Swish/ /usr/share/sddm/themes/
sudo sed -i 's/Current=.*/Current=Swish/' /etc/sddm.conf.d/kde_settings.conf


# *** Splash Screen
sudo tar -xzf $GITFOLDER/res/splash-screen/QuarksSplashDark.tar.gz -C $SHARE/plasma/look-and-feel/
sudo sed -i 's/Theme=.*/Theme=QuarksSplashDark/' $DOTCONFIG/ksplashrc

# *** Lock Screen
sudo sed -i 's|Image=.*|Image=home/jokerwrld/.local/share/wallpapers/SDDM-nightcity.jpg|g' $DOTCONFIG/kscreenlockerrc

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


# >>>>> Install Virtual Desktop Bar
git clone https://github.com/wsdfhjxc/virtual-desktop-bar.git ~/Downloads/virtual-desktop-bar
cd ~/Downloads/virtual-desktop-bar/
yes | ./scripts/install-dependencies-arch.sh
./scripts/install-applet.sh


# >>>>> Install And Configure Latte-Dock
#yes | yay -S latte-dock
# On Manjaro:
yes | sudo pamac build latte-dock-git


# >>>>> Install And Configure ZSH
# *** Auto-Suggestions Plugin | AUR
yes | yay -S zsh-autosuggestions

# *** Auto-Highlighting Plugin | AUR
yes | yay -S zsh-syntax-highlighting

# *** Auto-Jump Plugin | AUR
yes | yay -S autojump

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
konsave -i $GITFOLDER/res/konsave/JokerWrld-Theme.knsv
konsave -a JokerWrld-Theme.knsv


# >>>>> Cleaning Up The Downloads Folder
cd ~
rm -rf ~/Downloads/*