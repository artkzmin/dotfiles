# Client

## Оглавление
- [Desktop](desktop)
- [WSL](wsl)

## Шрифт в VS Code
В скрипте устанавливается шрифт DroidSansM. Для подключения его в VS Code нужно прописать следующее название:
```
DroidSansM Nerd Font, monospace
```

## Исправление ошибок
### SSH-ключи
Текст ошибки:
```bash
...Permission denied (publickey).
```
Необходимо изменить права доступа к файлам SSH-ключей:
```bash
sudo chmod 600 ~/.ssh/id_ed25519
```
```bash
sudo chmod 644 ~/.ssh/id_ed25519.pub
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
