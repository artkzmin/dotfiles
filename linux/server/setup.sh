#!/bin/sh

# Common setup
wget -qO- https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/common/setup.sh | bash

# /home
TMP_DIR=$(mktemp -d)
git clone --depth 1 https://github.com/artkzmin/dotfiles.git "$TMP_DIR"
cp -r "$TMP_DIR/linux/server/home/." "$HOME/"

# SSH
sudo wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/server/config/sshd_config
sudo service ssh restart
