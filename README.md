# My Dotfiles

Personal development environment configuration for macOS.

## Current Setup Includes

- **Shell**: Zsh with Oh My Zsh
- **Editor**: Vim with custom configuration
- **Version Control**: Git with personal config
- **Development**: Python (pyenv), Rust (rustup), Node.js
- **Tools**: FZF, Ollama AI, Docker, Colima
- **Applications**: VS Code, various Homebrew packages

## Quick Setup

```bash
git clone <this-repo-url> ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh
```

## What Gets Installed

- All Homebrew packages from Brewfile
- Oh My Zsh framework
- Development environments (pyenv, rustup)
- FZF fuzzy finder
- Vim configuration with plugins
- VS Code settings and extensions
- macOS system preferences

## Directory Structure

- `git/` - Git configuration
- `zsh/` - Zsh shell with Oh My Zsh setup
- `vim/` - Vim configuration and plugins
- `ssh/` - SSH client configuration (keys excluded)
- `vscode/` - VS Code settings and extensions
- `config/` - Modern app configs from ~/.config
- `fzf/` - Fuzzy finder configuration
- `rust/` - Rust development setup
- `pyenv/` - Python version management
- `ollama/` - AI model runner configuration

## Security Notes

- SSH private keys are excluded
- Sensitive history files are not tracked
- API keys and tokens should be in environment variables
- Review all files before committing to version control

## Adding New Configurations

1. Move config to appropriate directory
2. Use `stow` to create symlinks: `stow directory-name`
3. Commit changes to git

## Development Environment

This setup assumes macOS with Homebrew and includes configurations for:
- Python development with pyenv
- Rust development with rustup/cargo
- Node.js development
- Docker with Colima
- AI/ML tools (Ollama)
