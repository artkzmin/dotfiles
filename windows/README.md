# Windows

## Запуск скрипта
Запускать с правами администратора из PowerShell:
```ps1
$tmp=Join-Path $env:TEMP ("dotfiles-" + [guid]::NewGuid().ToString("N")); $zip="$tmp.zip"; Invoke-WebRequest -Uri "https://github.com/artkzmin/dotfiles/archive/refs/heads/main.zip" -OutFile $zip; Expand-Archive -Path $zip -DestinationPath $tmp; powershell -ExecutionPolicy Bypass -File (Join-Path $tmp "dotfiles-main\windows\setup.ps1")
```

Скрипт также скачивает обои с Яндекс Диска и копирует их в системную папку изображений пользователя в подпапку `Обои`

Для установки дополнительного NVIDIA ПО используйте флаг `-Nvidia`
Этот флаг скачивает и запускает NVIDIA-инсталляторы из отдельной папки `Installers NVIDIA` на Яндекс Диске

Команда запуска:
```ps1
$tmp=Join-Path $env:TEMP ("dotfiles-" + [guid]::NewGuid().ToString("N")); $zip="$tmp.zip"; Invoke-WebRequest -Uri "https://github.com/artkzmin/dotfiles/archive/refs/heads/main.zip" -OutFile $zip; Expand-Archive -Path $zip -DestinationPath $tmp; powershell -ExecutionPolicy Bypass -File (Join-Path $tmp "dotfiles-main\windows\setup.ps1") -Nvidia
```

## Установка Windows 11 без интернета

1. `Shift + F11`
2. Ввести:
  ```
  OOBE\BYPASSNRO
  ```
