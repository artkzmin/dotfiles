#!/bin/sh

# Common setup
wget -qO- https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/common/setup.sh | bash

sudo apt-get install -y poppler-utils vim-gtk3 tree nodejs cloc gh tig zlib1g-dev libbz2-dev libreadline-dev llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev liblzma-dev python3-dev python3-lxml libxslt-dev libffi-dev libssl-dev gnumeric libsqlite3-dev libpq-dev libxml2-dev libxslt1-dev libjpeg-dev libfreetype6-dev libcurl4-openssl-dev supervisor libfuse2 libxi6 libxrender1 libxtst6 mesa-utils libfontconfig libgtk-3-bin dbus-user-session libxcb-xinerama0 libxcb-cursor0 libzbar0

# lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
LAZYGIT_ARCH=$(uname -m | sed -e 's/aarch64/arm64/')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit -D -t /usr/local/bin/
sudo rm lazygit.tar.gz lazygit

# Pyenv
curl -fsSL https://pyenv.run | bash

# Poetry
# curl -sSL https://install.python-poetry.org | python3 -

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Taskfile
curl -1sLf 'https://dl.cloudsmith.io/public/task/task/setup.deb.sh' | sudo -E bash
sudo apt install task

# Go
sudo add-apt-repository ppa:longsleep/golang-backports
sudo apt update
sudo apt install golang-go

# NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
nvm install --lts
nvm use --lts
nvm alias default node

# PostgreSQL Client 18
sudo install -d /usr/share/postgresql-common/pgdg
curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc \
  | sudo gpg --dearmor -o /usr/share/postgresql-common/pgdg/pgdg.gpg
echo "deb [signed-by=/usr/share/postgresql-common/pgdg/pgdg.gpg] \
http://apt.postgresql.org/pub/repos/apt \
$(lsb_release -cs)-pgdg main" \
| sudo tee /etc/apt/sources.list.d/pgdg.list
sudo apt-get update
sudo apt-get install -y postgresql-client-18

# Codex
npm i -g @openai/codex
# MCP
npx playwright install chrome
# rtk
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh

# LM Studio
curl -fsSL https://lmstudio.ai/install.sh | bash

# /home
TMP_DIR=$(mktemp -d)
git clone --depth 1 https://github.com/artkzmin/dotfiles.git "$TMP_DIR"
cp -r "$TMP_DIR/linux/client/common/home/." "$HOME/"
rm -rf "$TMP_DIR"
