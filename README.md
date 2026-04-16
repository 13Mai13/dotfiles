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

#### 1. Xcode Command Line Tools

Git is not available out of the box on a fresh Mac. Install the CLI tools first:

```bash
sudo softwareupdate --install "$(softwareupdate --list 2>&1 | grep -o 'Command Line Tools for Xcode [^ ]*-[^ ]*' | head -1)"
```

#### 2. SSH Key

Generate a key, add it to your SSH agent (with macOS Keychain so the passphrase persists across reboots), and add the public key to GitHub:

```bash
ssh-keygen -t ed25519 -C "your-email@example.com" -f ~/.ssh/id_ed25519
```
```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

Then copy the output of `cat ~/.ssh/id_ed25519.pub` to [github.com/settings/keys](https://github.com/settings/keys).

Add GitHub to known hosts so the first clone doesn't prompt:

```bash
ssh-keyscan github.com >> ~/.ssh/known_hosts
```

#### 3. Clone and Install

```bash
mkdir -p ~/.mai_code && git clone git@github.com:13Mai13/dotfiles.git ~/.mai_code/dotfiles && cd ~/.mai_code/dotfiles && ./install.sh
```

The script will:
1. Install Homebrew (if not present)
2. Install all packages from Brewfile
3. Backup your existing dotfiles
4. Create symlinks using GNU Stow
5. Configure FZF and other tools

#### 4. Obsidian Vault and Plugins

The install script symlinks Obsidian config into `~/.mai_code/mai-notes` but skips if the vault doesn't exist. Run this after install to create the vault, install all plugins, and link the Minimal theme:

```bash
VAULT="$HOME/.mai_code/mai-notes" DOTS="$HOME/.mai_code/dotfiles" && mkdir -p "$VAULT/.obsidian/plugins/obsidian-style-settings" "$VAULT/.obsidian/plugins/obsidian-icon-folder" "$VAULT/.obsidian/plugins/obsidian-excalidraw-plugin" "$VAULT/.obsidian/plugins/code-styler" "$VAULT/.obsidian/themes/Minimal" && ln -sf "$DOTS/obsidian/.obsidian/appearance.json" "$VAULT/.obsidian/appearance.json" && ln -sf "$DOTS/obsidian/.obsidian/community-plugins.json" "$VAULT/.obsidian/community-plugins.json" && ln -sf "$DOTS/obsidian/.obsidian/core-plugins.json" "$VAULT/.obsidian/core-plugins.json" && ln -sf "$DOTS/obsidian/.obsidian/hotkeys.json" "$VAULT/.obsidian/hotkeys.json" && ln -sf "$DOTS/obsidian/.obsidian/templates.json" "$VAULT/.obsidian/templates.json" && ln -sf "$DOTS/obsidian/.obsidian/plugins/obsidian-style-settings/data.json" "$VAULT/.obsidian/plugins/obsidian-style-settings/data.json"
```

```bash
VAULT="$HOME/.mai_code/mai-notes" && for plugin in "obsidian-community/obsidian-style-settings:obsidian-style-settings:1.0.9" "FlorianWoelki/obsidian-iconize:obsidian-icon-folder:2.14.7" "zsviczian/obsidian-excalidraw-plugin:obsidian-excalidraw-plugin:2.22.0" "mayurankv/Obsidian-Code-Styler:code-styler:1.1.7"; do repo=$(echo $plugin | cut -d: -f1); id=$(echo $plugin | cut -d: -f2); ver=$(echo $plugin | cut -d: -f3); for f in main.js manifest.json styles.css; do curl -sL "https://github.com/$repo/releases/download/$ver/$f" -o "$VAULT/.obsidian/plugins/$id/$f"; done; done && curl -sL "https://github.com/kepano/obsidian-minimal/releases/download/8.1.7/theme.css" -o "$VAULT/.obsidian/themes/Minimal/theme.css" && curl -sL "https://github.com/kepano/obsidian-minimal/releases/download/8.1.7/manifest.json" -o "$VAULT/.obsidian/themes/Minimal/manifest.json" && echo "Obsidian setup done"
```

> After opening Obsidian, point it to `~/.mai_code/mai-notes` as the vault, then go to Settings → Community plugins and enable each plugin (required once for security).

### Manual Installation

If you prefer manual control:

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages
brew bundle install

# Stow configurations (run from ~/.mai_code/dotfiles)
stow zsh tmux starship ghostty aerospace sublime-text
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
