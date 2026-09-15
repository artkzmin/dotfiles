#!/bin/sh

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y vim tmux htop git curl wget unzip zip make net-tools bat rsync redis-tools postgresql-client dnsutils

# Docker
distro=$(grep '^ID=' /etc/os-release | cut -d= -f2 | tr -d '"')
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
if [[ "$distro" == "ubuntu" ]]; then
    echo "Docker for Ubuntu"
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
elif [[ "$distro" == "debian" ]]; then
    echo "Docker for Debian"
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
else
    echo "Unknown distro: $distro"
fi
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo usermod -aG docker $USER

# eza
sudo apt-get install -y gpg
sudo mkdir -p /etc/apt/keyrings
sudo rm -f /etc/apt/keyrings/gierens.gpg
sudo wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
sudo echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
sudo apt-get update
sudo apt-get install -y eza

# zsh
sudo apt-get install -y zsh

export RUNZSH=no
export CHSH=no
export KEEP_ZSHRC=yes
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k

# vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# tmux TPM: https://github.com/tmux-plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# /home
TMP_DIR=$(mktemp -d)
git clone --depth 1 https://github.com/artkzmin/dotfiles.git "$TMP_DIR"
cp -r "$TMP_DIR/linux/common/home/." "$HOME/"
rm -rf "$TMP_DIR"
