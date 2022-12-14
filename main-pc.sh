#!/bin/sh

#xrandr --output DP-0 --mode 1920x1080 --pos 0x0 --rate 74.97 --output DP-2 --primary --mode 1920x1080 --pos 1920x0 --rate 144 --output DP-4 --mode 1920x1080 --pos 3840x0 --rate 74.97

# Updating system
paru -Syu --noconfirm

paru -S etcher-bin gimp bitwarden spotify multimc-bin postman-bin arduino jre-openjdk telegram-desktop-bin ckb-next nvtop noto-fonts-cjk noto-fonts-emoji --noconfirm
echo 'awful.spawn.with_shell("discord --start-minimized")' >> /$HOME/.config/awesome/rc.lua

#Keyboard daemon for Corsair
sudo systemctl enable ckb-next-daemon

#Flatpak installs
#flatpak install flathub com.discordapp.Discord

#Steam
sudo pacman -S steam --noconfirm

#Mouse DPI
sudo touch /etc/modprobe.d/usbhid.conf
echo 'options usbhid mousepoll=4' | sudo tee -a /etc/modprobe.d/usbhid.conf
sudo modprobe -r usbhid && modprobe usbhid

# Installing GitHub
paru -S github-desktop-bin --noconfirm
mkdir /$HOME/documents/github

# Installing KVM
paru -S qemu libvirt virt-manager lxsession dnsmasq --noconfirm     #ebtables
sudo systemctl enable libvirtd
sudo usermod -G libvirt -a $USER

# monitor setup
echo 'awful.spawn.with_shell("xrandr --output DisplayPort-2 --mode 2560x1440 --rate 143.91 --primary")' >> /$HOME/.config/awesome/rc.lua
#cd /etc/X11/
#sudo curl -LO https://raw.githubusercontent.com/Prihler/dotfiles/main/xorg.conf
#cd $HOME

# Wake on lan
#paru -S wol-systemd --noconfirm
#sudo systemctl enable wol@enp39s0
#sudo systemctl start wol@enp39s0

# ssh
#paru -S openssh --noconfirm
#sudo systemctl enable sshd.service
#sudo systemctl start sshd.service

# Setting up script to run after next login
cd /opt && sudo curl -LO https://raw.githubusercontent.com/RyhoBtw/archSh/main/first-boot.sh
sudo chmod +x /opt/first-boot.sh
echo 'awful.spawn.with_shell("alacritty -e /opt/first-boot.sh")' >> /$HOME/.config/awesome/rc.lua

rm $HOME/main-pc.sh
