# Linux


## Запуск скрипта
Для Desktop:
```bash
wget -qO- https://raw.githubusercontent.com/artkzmin/linux-setup/main/client/setup-desktop.sh | bash
```
Для WSL:
```bash
wget -qO- https://raw.githubusercontent.com/artkzmin/linux-setup/main/client/setup-wsl.sh | bash
```


## Удаление драйверов NVIDIA
```bash
sudo apt-get remove --purge '^nvidia-.*'
```

## Git
Обработка строк для Windows:
```ps1
git config --global core.autocrlf true
git config --global core.safecrlf warn
```


## Исправление ошибок
### ssh-ключи
Текст ошибки:
```bash
sign_and_send_pubkey: signing failed for RSA "/home/artem/.ssh/id_rsa" from agent: agent refused operation
artem@192.168.0.103: Permission denied (publickey).
```
Необходимо изменить права доступа к файлам ssh-ключей:
```bash
sudo chmod 600 ~/.ssh/id_ed25519 ; \
sudo chmod 644 ~/.ssh/id_ed25519.pub
```
```bash
sudo chmod 600 ~/.ssh/id_rsa ; \
sudo chmod 644 ~/.ssh/id_rsa.pub
```
### zsh
Текст ошибки:
```bash
command not found
```
Изменить переменную:
```bash
PATH=/bin:/usr/bin:/usr/local/bin:${PATH}
export PATH
```


## Настройка DNS в WSL при использовании VPN
### 1. Отключить авто-генерацию `resolv.conf`
Открой файл `/etc/wsl.conf`:
```bash
sudo vim /etc/wsl.conf
```
Добавь в него следующие строки:
```
[network]
generateResolvConf = false
```
### 2. Удалить текущий resolv.conf
```
sudo rm /etc/resolv.conf
```
### 3. Создать новый resolv.conf с корректными DNS-серверами
```
sudo vim /etc/resolv.conf
```
Вставь в него:
```
nameserver 1.1.1.1
nameserver 1.0.0.1
nameserver 8.8.8.8
nameserver 8.8.4.4
```
### 4. Перезапустить WSL в PowerShell или cmd:
```
wsl --shutdown
```
