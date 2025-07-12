#!/bin/sh

# Обновление и базовые пакеты
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y vim tmux htop git curl wget unzip zip gcc build-essential make net-tools cloc

# Зависимости
sudo apt-get install -y vim-gtk3 tree zlib1g-dev libbz2-dev libreadline-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev liblzma-dev python3-dev python3-lxml libxslt-dev libffi-dev libssl-dev gnumeric libsqlite3-dev libpq-dev libxml2-dev libxslt1-dev libjpeg-dev libfreetype6-dev libcurl4-openssl-dev supervisor libfuse2 libxi6 libxrender1 libxtst6 mesa-utils libfontconfig libgtk-3-bin dbus-user-session libxcb-xinerama0 libxcb-cursor0 ; \

# eza
sudo apt-get install -y gpg
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt-get update
sudo apt-get install -y eza

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
# Docker пакеты
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Добавление пользователя в группу Docker
sudo usermod -aG docker artem

# Alacritty
mkdir -p ~/.config/alacritty/themes
git clone https://github.com/alacritty/alacritty-theme ~/.config/alacritty/themes
# Конфиг
wget -O ~/.config/alacritty/alacritty.toml https://raw.githubusercontent.com/artkzmin/linux-setup/main/client/alacritty.toml

# Pyenv
curl -sSL https://install.python-poetry.org | python3 -

# Poetry
curl -fsSL https://pyenv.run | bash

# zsh
sudo apt-get install -y zsh
# oh my zsh
export RUNZSH=no
export CHSH=no
export KEEP_ZSHRC=yes
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
# Конфиги
wget -O ~/.zshrc https://raw.githubusercontent.com/artkzmin/linux-setup/main/client/.zshrc
wget -O ~/.p10k.zsh https://raw.githubusercontent.com/artkzmin/linux-setup/main/client/.p10k.zsh

# vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
wget -O ~/.vimrc https://raw.githubusercontent.com/artkzmin/linux-setup/main/client/.vimrc

# Git
wget -O ~/.gitconfig https://raw.githubusercontent.com/artkzmin/linux-setup/main/client/.gitconfig

# Fix DNS
sudo bash -c 'echo -e "[network]\ngenerateResolvConf = false" > /etc/wsl.conf && rm -f /etc/resolv.conf && echo -e "nameserver 1.1.1.1\nnameserver 1.0.0.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4" > /etc/resolv.conf'
