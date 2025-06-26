#!/bin/sh

# Обновление и базовые пакеты
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y vim tmux htop git curl wget unzip zip gcc build-essential make net-tools cloc

# Зависимости
sudo apt-get install -y tree zlib1g-dev libbz2-dev libreadline-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev liblzma-dev python3-dev python3-lxml libxslt-dev libffi-dev libssl-dev gnumeric libsqlite3-dev libpq-dev libxml2-dev libxslt1-dev libjpeg-dev libfreetype6-dev libcurl4-openssl-dev supervisor libfuse2 libxi6 libxrender1 libxtst6 mesa-utils libfontconfig libgtk-3-bin dbus-user-session libxcb-xinerama0 libxcb-cursor0 ; \

# eza
sudo apt-get install -y gpg
sudo mkdir -p /etc/apt/keyrings
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt-get update
sudo apt-get install -y eza

# Шрифт
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf
fc-cache -f -v
cd ~

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
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
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Добавление пользователя в группу Docker
sudo usermod -aG docker artem

# Git
git config --global user.name artkzmin
git config --global user.email artkzmin@gmail.com
# Стандартная ветка
git config --global init.defaultBranch main
# Обработка окончаний строк
git config --global core.autocrlf input
git config --global core.safecrlf warn

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
apt-get install -y zsh
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
exec zsh
