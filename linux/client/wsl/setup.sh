#!/bin/sh

# Common setup
wget -qO- https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/client/common/setup.sh | bash

# Fix DNS
# sudo bash -c 'echo -e "[network]\ngenerateResolvConf = false" > /etc/wsl.conf'
# sudo rm -f /etc/resolv.conf
# sudo bash -c 'echo -e "nameserver 1.1.1.1\nnameserver 1.0.0.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4" > /etc/resolv.conf'

# uv
sudo ln -sf ~/.local/bin/uv /usr/local/bin/uv

# /home
TMP_DIR=$(mktemp -d)
git clone --depth 1 https://github.com/artkzmin/dotfiles.git "$TMP_DIR"
cp -r "$TMP_DIR/linux/client/wsl/home/." "$HOME/"
rm -rf "$TMP_DIR"
