# Command Reference Manual

Quick reference for all tools in this dotfiles setup.

## Package Management

### Homebrew
```bash
# Install from Brewfile
brew bundle install

# Update all packages
brew update && brew upgrade

# List installed packages
brew list

# Search for package
brew search <package>

# Uninstall package
brew uninstall <package>

# Cleanup old versions
brew cleanup
```

### UV (Python Package Manager)
```bash
# Create new project
uv init my-project

# Install dependencies
uv sync

# Add package
uv add <package>

# Remove package
uv remove <package>

# Run script with UV
uv run <script.py>

# Create virtual environment
uv venv

# Install package globally
uv tool install <package>
```

## Terminal & Shell

### Ghostty (Terminal)
```bash
# Config location: ~/.config/ghostty/config

# Keybindings:
# cmd+t          - New tab
# cmd+w          - Close tab
# cmd+shift+[    - Previous tab
# cmd+shift+]    - Next tab
# cmd+shift+d    - Split vertically
# cmd+d          - Split horizontally
# cmd+[          - Focus left pane
# cmd+]          - Focus right pane
```

### Zsh
```bash
# Config files: ~/.zshrc, ~/.zshenv

# Reload config
source ~/.zshrc

# Show shell options
setopt

# History search
ctrl+r

# Edit command in editor
ctrl+x ctrl+e
```

### Starship (Prompt)
```bash
# Config location: ~/.config/starship.toml

# Print config
starship print-config

# Reload config (restart shell)
exec zsh

# Preset configurations
starship preset nerd-font-symbols -o ~/.config/starship.toml
```

## Terminal Multiplexer

### Tmux
```bash
# Start new session
tmux
tmux new -s <session-name>

# List sessions
tmux ls

# Attach to session
tmux attach -t <session-name>
tmux a  # attach to last session

# Detach from session
ctrl+b d

# Create window
ctrl+b c

# Switch windows
ctrl+b n  # next
ctrl+b p  # previous
ctrl+b 0-9  # by number

# Split panes
ctrl+b %  # vertical split
ctrl+b "  # horizontal split

# Navigate panes
ctrl+b arrow-keys

# Resize panes
ctrl+b :resize-pane -D 5  # down
ctrl+b :resize-pane -U 5  # up
ctrl+b :resize-pane -L 5  # left
ctrl+b :resize-pane -R 5  # right

# Kill pane/window
ctrl+b x  # kill pane
ctrl+b &  # kill window

# Reload config
ctrl+b :source-file ~/.tmux.conf
```

## Window Management

### Aerospace
```bash
# Config location: ~/.config/aerospace/aerospace.toml

# Default keybindings (if using default config):
# alt+shift+h    - Move focus left
# alt+shift+j    - Move focus down
# alt+shift+k    - Move focus up
# alt+shift+l    - Move focus right

# alt+shift+1-9  - Switch to workspace
# alt+ctrl+1-9   - Move window to workspace

# alt+shift+f    - Toggle fullscreen
# alt+shift+r    - Reload config

# List workspaces
aerospace list-workspaces

# Move window to workspace
aerospace move-node-to-workspace <number>
```

## Development Tools

### Neovim
```bash
# Start editor
nvim <file>

# Config location: ~/.config/nvim/init.lua

# Basic commands (in normal mode):
# :q            - Quit
# :w            - Write/save
# :wq           - Save and quit
# :q!           - Quit without saving

# Movement:
# h j k l       - Left, down, up, right
# w             - Next word
# b             - Previous word
# 0             - Start of line
# $             - End of line
# gg            - Start of file
# G             - End of file

# Editing:
# i             - Insert mode
# a             - Append mode
# v             - Visual mode
# d             - Delete
# y             - Yank (copy)
# p             - Paste
# u             - Undo
# ctrl+r        - Redo

# Search:
# /pattern      - Search forward
# ?pattern      - Search backward
# n             - Next match
# N             - Previous match
```

### FZF (Fuzzy Finder)
```bash
# Search files
fzf

# Search command history
ctrl+r

# Change directory (if set up)
cd **<tab>

# Use with other commands
vim $(fzf)
cat $(fzf)

# Preview files
fzf --preview 'cat {}'
```

## Container & Virtualization

### Colima (Docker Runtime)
```bash
# Start Colima
colima start

# Stop Colima
colima stop

# Check status
colima status

# Delete and recreate
colima delete
colima start

# Start with more resources
colima start --cpu 4 --memory 8
```

### Docker
```bash
# List containers
docker ps
docker ps -a  # include stopped

# Run container
docker run <image>
docker run -it <image> bash  # interactive

# Stop container
docker stop <container-id>

# Remove container
docker rm <container-id>

# List images
docker images

# Remove image
docker rmi <image-id>

# Build image
docker build -t <name> .

# Docker Compose
docker-compose up
docker-compose up -d  # detached
docker-compose down
docker-compose logs
```

## CLI Utilities

### Tree
```bash
# Show directory structure
tree

# Limit depth
tree -L 2

# Show hidden files
tree -a

# Show only directories
tree -d

# Ignore patterns
tree -I 'node_modules|.git'
```

### Htop
```bash
# Interactive process viewer
htop

# Keybindings in htop:
# F1 - Help
# F2 - Setup
# F3 - Search
# F4 - Filter
# F5 - Tree view
# F6 - Sort by
# F9 - Kill process
# F10 - Quit
```

## Dotfile Management

### Stow
```bash
# Stow a package (create symlinks)
stow <package-name>

# Stow from dotfiles directory
cd ~/dotfiles
stow zsh
stow tmux
stow nvim

# Stow all packages
stow */

# Unstow (remove symlinks)
stow -D <package-name>

# Restow (refresh symlinks)
stow -R <package-name>

# Dry run (see what would happen)
stow -n <package-name>

# Target different directory
stow -t ~ <package-name>
```

## AWS Tools

### AWS CLI
```bash
# Configure credentials
aws configure

# List S3 buckets
aws s3 ls

# Copy to S3
aws s3 cp file.txt s3://bucket/

# List EC2 instances
aws ec2 describe-instances

# Get caller identity
aws sts get-caller-identity
```

### AWS Vault
```bash
# Add credentials
aws-vault add <profile>

# Execute command with profile
aws-vault exec <profile> -- aws s3 ls

# Login to AWS Console
aws-vault login <profile>

# List profiles
aws-vault list

# Remove credentials
aws-vault remove <profile>
```

## Productivity Apps

### Obsidian
- Knowledge base with markdown files
- Location: Choose your vault directory
- Sync using Git or Obsidian Sync

### Notion
- All-in-one workspace
- Web-based with desktop app
- Use for project management, notes, databases

## Theme - Catppuccin

Apply to different tools:

```bash
# Tmux
# Add to ~/.tmux.conf:
# set -g @plugin 'catppuccin/tmux'

# Neovim
# Add to init.lua:
# require("catppuccin").setup()
# vim.cmd.colorscheme "catppuccin"

# Ghostty
# Add to ~/.config/ghostty/config:
# theme = catppuccin-mocha

# Zsh/Starship
# Use catppuccin preset in starship
```

## Quick Setup on New Machine

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Clone dotfiles
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# 3. Install all packages
brew bundle install

# 4. Stow configurations
stow zsh tmux nvim ghostty aerospace

# 5. Reload shell
exec zsh
```
