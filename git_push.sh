#!/bin/bash

# Удаляем всю историю локально
rm -rf .git
git init

# Добавляем файлы как единственный новый коммит
git add .
git add -f AGENTS.md linux/client/common/home/.codex \
    macos/home/.codex \
    macos/home/.config/sketchybar/AGENTS.md
git commit -m "feat: update repository"

# Привязываем удалённый репозиторий
git remote add origin git@github.com:artkzmin/dotfiles.git

# Полностью перезаписываем удалённую историю
git push --force --set-upstream origin main
