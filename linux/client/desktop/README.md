# Desktop

## Запуск скрипта
```bash
wget -qO- https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/client/desktop/setup.sh | bash
```


## Удаление драйверов NVIDIA
```bash
sudo apt-get remove --purge '^nvidia-.*'
```


## Ускорение Pycharm
```
echo 'fs.inotify.max_user_watches = 524288' | sudo tee /etc/sysctl.d/60-jetbrains.conf > /dev/null
sudo sysctl -p --system
```
