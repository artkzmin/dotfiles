#!/bin/sh

# Common setup
wget -qO- https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/common/setup.sh | bash

# Config
wget -O ~/.p10k.zsh https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/server/config/.p10k.zsh
wget -O ~/.zshrc https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/server/config/.zshrc
wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/server/config/sshd_config && service ssh restart