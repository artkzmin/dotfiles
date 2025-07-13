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


## Создание пользователя
```bash
sudo adduser deploy
sudo usermod -aG sudo deploy
sudo usermod -aG docker deploy
su - deploy
```


## Телеметрия Timeweb
```bash
wget -O - http://zabbix.repo.timeweb.ru/zabbix-install.sh | bash
```