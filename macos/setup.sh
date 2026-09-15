/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

curl https://sh.rustup.rs -sSf | sh
cargo install eza

export RUNZSH=no
export CHSH=no
export KEEP_ZSHRC=yes
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"


# Интерактивно выбрать вариант установка - ввести число от 1 до 3
curl https://sh.rustup.rs -sSf | sh

brew install tmux
brew install --cask codex
brew install rtk

brew install zbar
brew install node
brew install lazygit
brew install macmon

brew tap FelixKratz/formulae
brew trust --formula felixkratz/formulae/sketchybar
brew install sketchybar
brew install --cask font-hack-nerd-font
mkdir -p ~/.config/sketchybar/plugins
cp $(brew --prefix)/share/sketchybar/examples/sketchybarrc ~/.config/sketchybar/sketchybarrc
cp -r $(brew --prefix)/share/sketchybar/examples/plugins/ ~/.config/sketchybar/plugins/

# Изменить принцип группировки окон для Aerospace
defaults write com.apple.dock expose-group-apps -bool true
killall Dock
defaults read com.apple.dock expose-group-apps

# vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# tmux TPM: https://github.com/tmux-plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Font
mkdir -p "$HOME/Library/Fonts"
curl -fsSL \
  -o "$HOME/Library/Fonts/DroidSansMNerdFont-Regular.otf" \
  https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf

# /home
TMP_DIR=$(mktemp -d)
git clone --depth 1 https://github.com/artkzmin/dotfiles.git "$TMP_DIR"
cp -r "$TMP_DIR/macos/home/." "$HOME/"
rm -rf "$TMP_DIR"
