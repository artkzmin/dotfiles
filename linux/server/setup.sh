#!/bin/sh

# Common setup
wget -qO- https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/common/setup.sh | bash

sudo apt-get install -y ufw tcpdump

# Configure swap (4 GiB total)
TARGET_SWAP=$((4 * 1024 * 1024 * 1024))
SWAPFILE=/swapfile
# Disable existing swapfile
if swapon --noheadings --show=NAME | grep -Fxq "$SWAPFILE"; then
    swapoff "$SWAPFILE" || exit 1
fi
rm -f "$SWAPFILE"
# Calculate existing swap
EXISTING_SWAP=$(swapon --noheadings --bytes --show=SIZE |
    awk '{sum += $1} END {printf "%.0f", sum}')
if [ "$EXISTING_SWAP" -gt "$TARGET_SWAP" ]; then
    echo "Existing swap exceeds 4 GiB"
    exit 1
fi
# Update fstab
cp /etc/fstab /etc/fstab.bak
sed -i '\|^[[:space:]]*/swapfile[[:space:]]|d' /etc/fstab
# Create additional swap if needed
if [ "$EXISTING_SWAP" -lt "$TARGET_SWAP" ]; then
    PAGE_SIZE=$(getconf PAGESIZE)
    FILE_SIZE=$((TARGET_SWAP - EXISTING_SWAP + PAGE_SIZE))

    fallocate -l "$FILE_SIZE" "$SWAPFILE" || exit 1
    chmod 600 "$SWAPFILE"
    mkswap "$SWAPFILE" || exit 1
    swapon "$SWAPFILE" || exit 1

    echo "$SWAPFILE none swap sw 0 0" >> /etc/fstab
fi
# Verify
swapon --show
free -h

# /home
TMP_DIR=$(mktemp -d)
git clone --depth 1 https://github.com/artkzmin/dotfiles.git "$TMP_DIR"
cp -r "$TMP_DIR/linux/server/home/." "$HOME/"

# SSH
sudo wget -O /etc/ssh/sshd_config https://raw.githubusercontent.com/artkzmin/dotfiles/main/linux/server/config/sshd_config
sudo service ssh restart
