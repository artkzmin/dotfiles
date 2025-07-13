# Desktop

## Запуск скрипта
```bash
wget -qO- https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/client/desktop/setup.sh | bash
```


## Удаление драйверов NVIDIA
```bash
sudo apt-get remove --purge '^nvidia-.*'
```