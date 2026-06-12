# Dotfiles for GitHub Codespaces (Minimal)

Personal dotfiles optimized for GitHub Codespaces (Linux), focusing on a minimal and fast environment.

## Contents

- **Neovim**: Minimal configuration using [Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) with Primeagen-style enhancements.
- **Tmux**: Terminal multiplexer with custom status line and theme.
- **Git**: Customized git settings and delta for better diffs.
- **Eza**: Modern replacement for `ls`.

## Installation

Run the installation script in your Codespaces environment:

```bash
./install.sh
```

This script will:
1. Symlink configuration files to your home directory.
2. Install system dependencies via `apt` (tmux, fzf, ripgrep, fd, delta).
3. Install `neovim` (latest version via extracted AppImage).
4. Install `eza`.
5. Install `gemini-cli`.

## Authentication (Gemini CLI)

To automatically authenticate the Gemini CLI in your Codespaces:

1. Go to your GitHub [Settings > Codespaces > Secrets](https://github.com/settings/codespaces/secrets).
2. Add a new secret named `GEMINI_API_KEY`.
3. Set its value to your Gemini API Key (get one from [Google AI Studio](https://aistudio.google.com/app/apikey)).
4. Select this repository (`dotfiles-public`) in the "Repository access" section.

Once set, the Gemini CLI will be ready to use immediately upon opening your Codespace.
