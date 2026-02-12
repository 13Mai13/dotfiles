#!/bin/bash

# Dotfiles Installation Script
# This script will install all dependencies and set up your dotfiles

set -e

echo "🚀 Starting dotfiles installation..."
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Helper functions
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    print_info "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    print_success "Homebrew installed"
else
    print_success "Homebrew already installed"
fi

# Update Homebrew
print_info "Updating Homebrew..."
brew update
print_success "Homebrew updated"

# Install packages from Brewfile
print_info "Installing packages from Brewfile..."
if [ -f "Brewfile" ]; then
    brew bundle install
    print_success "All packages installed"
else
    print_error "Brewfile not found"
    exit 1
fi

# Create backup directory
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
print_info "Backup directory created: $BACKUP_DIR"

# Backup existing dotfiles
print_info "Backing up existing dotfiles..."
for file in ~/.zshrc ~/.tmux.conf; do
    if [ -f "$file" ]; then
        cp "$file" "$BACKUP_DIR/"
        print_success "Backed up $(basename $file)"
    fi
done

# Backup existing config directories
for dir in ~/.config/starship ~/.config/ghostty ~/.config/aerospace ~/Library/Application\ Support/Sublime\ Text; do
    if [ -d "$dir" ]; then
        cp -r "$dir" "$BACKUP_DIR/"
        print_success "Backed up $(basename $dir)"
    fi
done

# Use stow to symlink dotfiles
print_info "Creating symlinks with stow..."
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES_DIR"

# Stow each package
for package in zsh tmux starship ghostty aerospace sublime-text; do
    if [ -d "$package" ]; then
        stow -t "$HOME" "$package" 2>&1 | grep -v "BUG in find_stowed_path" || true
        print_success "Stowed $package"
    fi
done

# Setup FZF
print_info "Setting up FZF..."
if command -v fzf &> /dev/null; then
    $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
    print_success "FZF configured"
fi

# Setup Python with UV
print_info "Setting up Python with UV..."
if command -v uv &> /dev/null; then
    # Install commonly used Python tools
    uv tool install ruff
    uv tool install black
    print_success "Python tools installed with UV"
fi

# Start Colima (if installed)
if command -v colima &> /dev/null; then
    print_info "Starting Colima..."
    colima start --cpu 4 --memory 8 2>/dev/null || print_info "Colima already running or failed to start"
fi

# Configure Git (if not already configured)
if [ -z "$(git config --global user.name)" ]; then
    print_info "Git user.name not set. Please configure:"
    read -p "Enter your name: " git_name
    git config --global user.name "$git_name"
fi

if [ -z "$(git config --global user.email)" ]; then
    print_info "Git user.email not set. Please configure:"
    read -p "Enter your email: " git_email
    git config --global user.email "$git_email"
fi
print_success "Git configured"

# Final steps
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
print_success "Installation complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
print_info "Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Install Tmux Plugin Manager (optional):"
echo "     git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm"
echo "  3. Open tmux and press Ctrl+Space + I to install plugins"
echo "  4. Start Aerospace: open -a AeroSpace"
echo "  5. Check COMMANDS.md for usage reference"
echo ""
print_info "Your old dotfiles are backed up in: $BACKUP_DIR"
echo ""
