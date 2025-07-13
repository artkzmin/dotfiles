#!/bin/sh

# Common setup
wget -qO- https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/client/common/setup.sh | bash

# Fix DNS
sudo bash -c 'echo -e "[network]\ngenerateResolvConf = false" > /etc/wsl.conf
rm -f /etc/resolv.conf
echo -e "nameserver 1.1.1.1\nnameserver 1.0.0.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4" > /etc/resolv.conf'