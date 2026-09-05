# WSL

## Запуск скрипта
```bash
wget -qO- https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/client/wsl/setup.sh | bash
```


## После исполнения скрипта
```bash
chsh -s $(which zsh)
exec zsh
```


## Чиним DNS в Windows 11
В Windows создать файл `%UserProfile%\.wslconfig` со следующими строками:
```ini
[wsl2]
networkingMode=mirrored
dnsTunneling=true
firewall=true
```
После этого перезапуск из Powershell или cmd:
```ps1
wsl --shutdown
```


## Чиним Docker в Windows 11
Ошибка:
```bash
failed to connect to the docker API at unix:///var/run/docker.sock; check if the path is correct and if the daemon is running: dial unix /var/run/docker.sock: connect: no such file or directory
```
Команда для исправления:
```bash
sudo tee /etc/wsl.conf >/dev/null <<'EOF'
[boot]
systemd=true
EOF
```
После этого перезапуск из Powershell или cmd:
```ps1
wsl --shutdown
```


## Чиним LM Studio
1. Нужно установть [LM Studio](https://lmstudio.ai) в Windows.
2. Скопировать ключ из `%USERPROFILE%\.lmstudio\.internal\lms-key-2`
3. Вставить его по аналогичному пути в WSL:
   ```bash
   vim .lmstudio/.internal/lms-key-2
   ```
4. Выполнить:
   ```bash
   lms daemon up
   ```
