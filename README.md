# Dotfiles for GitHub Codespaces

Personal dotfiles optimized for GitHub Codespaces (Linux).

## Contents

- **Neovim**: Advanced editor configuration using LazyVim.
- **Fish Shell**: Modern shell with plugins (Fisher, Tide, z, fzf).
- **Tmux**: Terminal multiplexer with custom status line and theme.
- **Git**: Customized git aliases and settings.

## Installation

Run the installation script in your Codespaces environment:

```bash
./install.sh
```

This script will:
1. Symlink configuration files to your home directory.
2. Install system dependencies via `apt`.
3. Install `neovim` (latest version), `lazygit`, and `eza`.
4. Install `gemini-cli`.

## Authentication (Gemini CLI)

To automatically authenticate the Gemini CLI in your Codespaces:

1.  Go to your GitHub [Settings > Codespaces > Secrets](https://github.com/settings/codespaces/secrets).
2.  Add a new secret named `GEMINI_API_KEY`.
3.  Set its value to your Gemini API Key (get one from [Google AI Studio](https://aistudio.google.com/app/apikey)).
4.  Select this repository (`dotfiles-public`) in the "Repository access" section.

Once set, the Gemini CLI will be ready to use immediately upon opening your Codespace.

