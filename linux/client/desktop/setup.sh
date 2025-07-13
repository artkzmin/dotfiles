#!/bin/sh

# Common setup
wget -qO- https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/client/common/setup.sh | bash

# Font
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf
fc-cache -f -v
cd ~

# Flathub
sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Alacritty
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes

# Config
wget -O ~/.config/alacritty/alacritty.toml https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/client/desktop/config/alacritty.toml