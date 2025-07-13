#!/bin/sh

# Common setup
wget -qO- https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/common/setup.sh | bash

sudo apt-get install -y cloc
sudo apt-get install -y vim-gtk3 tree zlib1g-dev libbz2-dev libreadline-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev liblzma-dev python3-dev python3-lxml libxslt-dev libffi-dev libssl-dev gnumeric libsqlite3-dev libpq-dev libxml2-dev libxslt1-dev libjpeg-dev libfreetype6-dev libcurl4-openssl-dev supervisor libfuse2 libxi6 libxrender1 libxtst6 mesa-utils libfontconfig libgtk-3-bin dbus-user-session libxcb-xinerama0 libxcb-cursor0 ; \

# Pyenv
curl -sSL https://install.python-poetry.org | python3 -

# Poetry
curl -fsSL https://pyenv.run | bash

# Config
wget -O ~/.gitconfig https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/common/config/.gitconfig
wget -O ~/.p10k.zsh https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/common/config/.p10k.zsh
wget -O ~/.zshrc https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/common/config/.zshrc