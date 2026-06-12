#!/bin/bash

set -e

DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)

echo "Installing dotfiles from $DOTFILES_DIR..."

# Create necessary directories
mkdir -p "$HOME/.config"

# Function to create symlinks
link_file() {
    local src=$1
    local dst=$2
    
    if [ -e "$dst" ] && [ ! -L "$dst" ]; then
        echo "Backing up existing file: $dst"
        mv "$dst" "$dst.bak"
    fi
    
    echo "Linking $src -> $dst"
    ln -sf "$src" "$dst"
}

# Link .config subdirectories
for dir in "$DOTFILES_DIR"/.config/*; do
    if [ -d "$dir" ]; then
        link_file "$dir" "$HOME/.config/$(basename "$dir")"
    fi
done

# Link root dotfiles
link_file "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/.gitignore" "$HOME/.gitignore"
link_file "$DOTFILES_DIR/.czrc" "$HOME/.czrc"

# Link .scripts directory
link_file "$DOTFILES_DIR/.scripts" "$HOME/.scripts"

echo "Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y \
    fish \
    tmux \
    fzf \
    ripgrep \
    fd-find \
    git-delta \
    build-essential \
    curl \
    ca-certificates

# Install Neovim (Latest via AppImage)
echo "Installing Neovim..."
if ! command -v nvim &> /dev/null || nvim --version 2>&1 | grep -q "FUSE"; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
    chmod u+x nvim-linux-x86_64.appimage
    # GitHub Codespaces doesn't support FUSE, so we extract the AppImage
    ./nvim-linux-x86_64.appimage --appimage-extract > /dev/null
    sudo mkdir -p /opt/nvim
    sudo cp -r squashfs-root/* /opt/nvim/
    sudo ln -sf /opt/nvim/usr/bin/nvim /usr/local/bin/nvim
    rm -rf squashfs-root nvim-linux-x86_64.appimage
fi

# Install Lazygit
echo "Installing Lazygit..."
if ! command -v lazygit &> /dev/null; then
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin/
    rm lazygit.tar.gz lazygit
fi

# Install Eza
echo "Installing Eza..."
if ! command -v eza &> /dev/null; then
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza
fi

# Install Fisher and plugins for Fish
echo "Setting up Fish plugins..."
if command -v fish &> /dev/null; then
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher"
    fish -c "fisher install jethrokuan/z"
    fish -c "fisher install PatrickF1/fzf.fish"
fi

# Install Gemini CLI
echo "Installing Gemini CLI..."
# Codespaces has npm/node pre-installed
if command -v npm &> /dev/null; then
    sudo npm install -g @google/gemini-cli
    
    if [ -z "$GEMINI_API_KEY" ]; then
        echo "Tip: Set the GEMINI_API_KEY secret in your GitHub Codespaces settings to enable automatic authentication."
    else
        echo "Gemini CLI authenticated via GEMINI_API_KEY environment variable."
    fi
else
    echo "npm not found, skipping Gemini CLI installation."
fi

echo "Dotfiles installation and software setup complete!"
