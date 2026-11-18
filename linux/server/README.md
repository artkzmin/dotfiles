# Server

## Запуск скрипта
```bash
wget -qO- https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/server/setup.sh | bash
```

## После исполнения скрипта
```bash
chsh -s $(which zsh)
exec zsh
```

После создания `.ssh/authorized_keys` выставить в `/etc/ssh/sshd_config`:
```bash
sudo vim /etc/ssh/sshd_config
```
```bash
PasswordAuthentication no
```
И выполнить:
```bash
sudo service ssh restart
```

## Установка [Dokploy](https://dokploy.com/)
```bash
curl -sSL https://dokploy.com/install.sh | sh
```

## Создание пользователя `www`
```bash
sudo adduser www
sudo usermod -aG sudo www
su - www
```

## Телеметрия Timeweb
```bash
wget -O - http://zabbix.repo.timeweb.ru/zabbix-install.sh | bash
```

## Решение проблем

### E: Could not get lock /var/lib/dpkg/lock-frontend. It is held by process `КОД` (apt-get)
Выполнить:
```
sudo kill -9 КОД
sudo dpkg --configure -a
```
