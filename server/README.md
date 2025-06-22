# Скрипт для автоматической настройки сервера при создании

```sh
#!/bin/sh

apt-get update && apt-get upgrade -y
apt-get install -y vim tmux htop git curl wget unzip zip gcc build-essential make net-tools

# eza
apt-get install -y gpg
mkdir -p /etc/apt/keyrings
rm -f /etc/apt/keyrings/gierens.gpg
wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | tee /etc/apt/sources.list.d/gierens.list
chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
apt-get update
apt-get install -y eza

# Docker
apt-get update
apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# ssh
wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/artkzmin/linux-setup/main/server/sshd_config
service ssh restart

# zsh
apt-get install -y zsh

export RUNZSH=no
export CHSH=no
export KEEP_ZSHRC=yes
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
wget -O /root/.zshrc https://raw.githubusercontent.com/artkzmin/linux-setup/main/server/.zshrc
wget -O /root/.p10k.zsh https://raw.githubusercontent.com/artkzmin/linux-setup/main/server/.p10k.zsh

# Timeweb
wget -O - http://zabbix.repo.timeweb.ru/zabbix-install.sh | bash
```
