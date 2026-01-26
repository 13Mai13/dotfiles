# Dotfiles

My macOS development environment configuration using GNU Stow for symlink management.

## Features

- **Window Manager**: Aerospace (tiling window manager)
- **Terminal**: Ghostty with Catppuccin theme
- **Shell**: Zsh with Starship prompt
- **Multiplexer**: Tmux with vim-like keybindings
- **Theme**: Catppuccin Mocha across all tools
- **Package Manager**: Homebrew + UV for Python

## Quick Start

### New Machine Setup

```bash
# Clone this repository
git clone https://github.com/13Mai13/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the installation script
./install.sh
```

The script will:
1. Install Homebrew (if not present)
2. Install all packages from Brewfile
3. Backup your existing dotfiles
4. Create symlinks using GNU Stow
5. Configure FZF and other tools

### Manual Installation

If you prefer manual control:

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages
brew bundle install

# Stow configurations
stow zsh
stow tmux
stow starship
stow ghostty
stow aerospace
```

## Structure

```
dotfiles/
├── Brewfile                    # Homebrew package definitions
├── COMMANDS.md                 # Quick reference for all tools
├── install.sh                  # Bootstrap installation script
├── zsh/
│   └── .zshrc                 # Zsh configuration
├── tmux/
│   └── .tmux.conf            # Tmux configuration
├── starship/
│   └── .config/starship/
│       └── starship.toml     # Starship prompt config
├── ghostty/
│   └── .config/ghostty/
│       └── config            # Ghostty terminal config
└── aerospace/
    └── .config/aerospace/
        └── aerospace.toml    # Aerospace window manager config
```

## Usage

### Adding New Configurations

1. Create a new directory for the tool
2. Mirror the home directory structure
3. Add your config files
4. Commit the changes
5. Use stow to symlink: `stow <tool-name>`

Example:
```bash
mkdir -p nvim/.config/nvim
vim nvim/.config/nvim/init.lua
git add nvim
git commit -m "feat: add neovim configuration"
stow nvim
```

### Updating Configurations

```bash
# Pull latest changes
git pull

# Restow to update symlinks
stow -R zsh tmux starship ghostty aerospace
```

### Removing Configurations

```bash
# Unstow (remove symlinks)
stow -D <tool-name>
```

## Key Bindings

### Tmux (Prefix: Ctrl+Space)
- `|` - Split vertical
- `-` - Split horizontal
- `h/j/k/l` - Navigate panes (vim-style)
- `r` - Reload config

### Aerospace (Modifier: Alt)
- `h/j/k/l` - Focus window
- `Shift+h/j/k/l` - Move window
- `1-9` - Switch workspace
- `Shift+1-9` - Move to workspace
- `f` - Toggle fullscreen
- `r` - Enter resize mode

### Zsh Aliases
- `ll` - Long list with hidden files
- `v` - Open Neovim
- `code-mai` - Jump to ~/.mai_code
- `dots` - Jump to dotfiles directory
- `gs/ga/gc/gp` - Git shortcuts

See [COMMANDS.md](COMMANDS.md) for complete reference.

## Installed Tools

### CLI Tools
- **fzf** - Fuzzy finder
- **htop** - Process viewer
- **tree** - Directory structure
- **stow** - Symlink manager

### Development
- **neovim** - Text editor
- **node** - JavaScript runtime
- **pyenv** - Python version manager
- **uv** - Modern Python package manager

### Container & Cloud
- **colima** - Docker runtime
- **docker** - Container platform
- **aws-vault** - AWS credentials manager
- **awscli** - AWS CLI

### Productivity
- **Notion** - Note-taking and collaboration
- **Obsidian** - Markdown knowledge base

## Theme

This setup uses **Catppuccin Mocha** theme across:
- Ghostty terminal
- Starship prompt
- Tmux (when using TPM)
- Neovim (when configured)

## Backup

The install script automatically backs up existing dotfiles to:
```
~/.dotfiles_backup_YYYYMMDD_HHMMSS/
```

## Troubleshooting

### Stow Conflicts
If stow reports conflicts:
```bash
# Remove the conflicting file
rm ~/.zshrc

# Try stowing again
stow zsh
```

### Homebrew Issues
```bash
# Update Homebrew
brew update

# Verify Brewfile
brew bundle check

# Reinstall packages
brew bundle install --force
```

### SSH Keys
Make sure your SSH keys are set up for GitHub:
```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
ssh-add ~/.ssh/id_ed25519
```

## Resources

- [GNU Stow Manual](https://www.gnu.org/software/stow/manual/stow.html)
- [Catppuccin Theme](https://github.com/catppuccin/catppuccin)
- [Aerospace Docs](https://nikitabobko.github.io/AeroSpace/guide)
- [Starship Config](https://starship.rs/config/)

## Contributing

This is my personal dotfiles repository, but feel free to fork and adapt for your own use!

## License

MIT
