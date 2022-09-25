#!/bin/sh

clear
cat <<'END'
  _    __                           
 (_)  / _|                          
  _  | |_   _   _   _ __ ___    ___ 
 | | |  _| | | | | | '_ ` _ \  / __|
 | | | |   | |_| | | | | | | | \__ \
 |_| |_|    \__,_| |_| |_| |_| |___/
END
sleep 1
clear

# asking stuff
clear
read -p "Is this the main pc? [y/n] " response_pgsh
clear

#if (whiptail --yesno "What to do after the script finished" --yes-button "poweroff" --no-button "reboot" 7 40); then
    poweroff_q=true
#fi
#echo $poweroff_q
#clear

read -p "Poweroff instead of restart? [y/n] " response_pow
clear
cd ~

# removing the need of a paswd during the script
echo '%wheel ALL=(ALL) NOPASSWD: ALL' | sudo EDITOR='tee -a' visudo

# Updating system
sudo pacman -Syu --noconfirm
# Installing needed packages for the script
sudo pacman -S base-devel git imagemagick --needed --noconfirm
git clone https://gitlab.com/rhyo_/archsh-temp

# Updating pacman keyring
sudo pacman-key --populate archlinux

# xdg-user-dirs
sudo pacman -S xdg-user-dirs --noconfirm
mkdir $HOME/misc
mkdir $HOME/downloads
xdg-user-dirs-update --set DOWNLOAD $HOME/downloads
mkdir $HOME/misc/public
xdg-user-dirs-update --set PUBLICSHARE $HOME/misc/public
mkdir $HOME/documents
xdg-user-dirs-update --set DOCUMENTS $HOME/documents
mkdir $HOME/misc/music
xdg-user-dirs-update --set MUSIC $HOME/misc/music
mkdir $HOME/pictures
xdg-user-dirs-update --set PICTURES $HOME/pictures
mkdir $HOME/pictures/videos
xdg-user-dirs-update --set VIDEOS $HOME/pictures/videos
mkdir $HOME/misc/desktop
xdg-user-dirs-update --set DESKTOP $HOME/misc/desktop
mkdir $HOME/documents/templates
xdg-user-dirs-update --set TEMPLATES $HOME/documents/templates

# move go directroy
export GOPATH="$XDG_DATA_HOME"/go

# Installing Paru
paru -Syu || { git clone https://aur.archlinux.org/paru.git ; cd paru ; makepkg -si --noconfirm ; sudo rm -r $HOME/paru ;}

# Installing extra firmware
paru -S mkinitcpio-firmware --noconfirm

# creating scripts
paru -S aria2 --noconfirm
cd /opt/
sudo curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/arch-iso.sh
sudo chmod +x /opt/arch-iso.sh
cd ~
mkdir ~/pictures/scripts-pic
cp ~/archSh-tmp/notify-arch.png ~/pictures/scripts-pic

# changing bash-files location
mkdir -p ~/.config/bash/
mkdir -p ~/.cache/bash/
mv ~/.bash_history ~/.cache/bash/
mv ~/.bash_logout ~/.cache/bash/
mv ~/.bash_profile ~/.config/bash/
mv ~/.bashrc ~/.config/bash/

# Installing dash
sudo pacman -S dash --noconfirm
sudo ln -sfT /bin/dash /bin/sh
cd /usr/share/libalpm/hooks/
sudo curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/bash-update.hook
cd ~

# Installing zsh
paru -S zsh zsh-syntax-highlighting zsh-theme-powerlevel10k-git --noconfirm
mkdir -p ~/.cache/zsh
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/.zshenv
mkdir -p ~/.config/zsh/
cd ~/.config/zsh
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/.zshrc
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/.p10k.zsh
cd ~
# zsh plugins


# aliases
cd ~/.config
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/aliasrc

# Installing doas

# Alacritty config & Picom
sudo pacman -S picom --noconfirm
mkdir -p ~/.config/alacritty/
cd ~/.config/alacritty/
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/alacritty.yml
cd ~

# Awesome config
mkdir -p ~/.config/awesome/
cd ~/.config/awesome
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/rc.lua
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/mytheme.lua
git clone https://github.com/Elv13/collision
cd ~

# rofi
paru -S rofi --noconfirm
mkdir ~/.config/rofi
cd ~/.config/rofi
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/config.rasi
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/power.rasi
cd ~

# Wallpaper
cd $HOME/pictures
git clone https://gitlab.com/Prihler/wallpaper.git
cd $HOME
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/.fehbg
chmod +x $HOME/.fehbg

# Themes
paru -S lxappearance --noconfirm
paru -S qogir-gtk-theme-git oxygen-cursors --noconfirm
mkdir $HOME/.config/gtk-3.0
cd $HOME/.config/gtk-3.0
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/settings.ini
cd $HOME
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/.gtkrc-2.0
mkdir -p $HOME/.icons/default/
cd $HOME/.icons/default/
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/index.theme
cd $HOME


# Installing SDDM
paru -S sddm sddm-sugar-candy-git --noconfirm
sudo systemctl enable sddm.service
sudo mkdir /etc/sddm.conf.d/
cd /etc/sddm.conf.d/
sudo curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/sddm.conf
sudo cp ~/ifums-tmp/sddm-paper-plane.jpg /usr/share/sddm/themes/sugar-candy/Backgrounds/
cd /usr/share/sddm/themes/sugar-candy/
sudo rm /usr/share/sddm/themes/sugar-candy/theme.conf
sudo curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/theme.conf
cd $HOME
cd /etc/X11/xorg.conf.d/
sudo curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/52-resolution-fix.conf
cd ~

# Theming Grub
sudo rm /etc/default/grub
cd /etc/default/
sudo curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/grub
cd ~
git clone https://github.com/vinceliuice/grub2-themes
cp ~/ifums-tmp/grub-rocket-dark.jpg ~/grub2-themes/background.jpg
sudo ~/grub2-themes/install.sh -b -t whitesur -s 1080p -i white
sudo rm -r grub2-themes
sudo sed -i 's/, with Linux linux//g' /boot/grub/grub.cfg
paru -S grub-customizer --noconfirm

# Installing fonts
paru -S ttf-ms-fonts nerd-fonts-jetbrains-mono noto-fonts-cjk ttf-ancient-fonts fonts-noto-hinted --noconfirm

# Setting up the printer
#paru -S cups
#sudo systemctl enable --now cups
#sudo usermod -aG lp $USER
#paru -S system-config-printer

# Setting up redshift
paru -S redshift-minimal --noconfirms
cd $HOME/.config
curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/redshift.conf
cd $HOME

# Setting up timeshift
paru -S timeshift --noconfirm
cd /opt
sudo curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/timeshift-setup.sh
sudo chmod +x /opt/timeshift-setup.sh
cd $HOME

# Setting up audio
paru -S pipewire pipewire-alsa pipewire-jack pipewire-pulse gst-plugin-pipewire libpulse wireplumbe alsa-ucm-conf-git carla --noconfirm
systemctl enable --user pipewire-pulse.service

# creating GnuPG directory
mkdir $HOME/.local/share/gnupg/

# removing unwanted packages
paru -R xterm xtermG i3 nano vim --noconfirm

# Installing packages
paru -S librewolf-bin libreoffice-fresh --noconfirm
paru -S nemo signal-desktop-beta-bin solaar ranger lf tldr bat downgrade ripgrep procs rsync flameshot man xdg-ninja exfat-utils fzf galculator btop redshift-minimal arandr mpv peazip cups qbittorrent --noconfirm

# Setting up Neovim
paru -S neovim --noconfirm

# Setting up ripgrep
mkdir $HOME/.config/ripgrep
touch $HOME/.config/ripgrep/ripgreprc

# remove script
sudo rm -r ~/archSh-tmp
rm archSh.sh

# possibly starting main-pc.sh
case "$response_pgsh" in
   [yYjJ]) curl -LO https://raw.githubusercontent.com/Prihler/ifums/main/main-pc.sh
           chmod +x main-pc.sh
           $HOME/main-pc.sh;;
   ?);;
esac

# adding the need for a passwd
sudo sed -i '$ d' /etc/sudoers

case "$response_pow" in
   [yYjJ]) poweroff;;
   ?);;
esac

#if $poweroff_q; then
#	poweroff
#fi

reboot