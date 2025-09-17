#!/bin/bash

# install.sh - Set up YOUR dotfiles on a new machine

set -e

DOTFILES_DIR="$HOME/.dotfiles"

echo "🚀 Setting up your dotfiles..."

# Check if we're in the dotfiles directory
if [ ! -f "$DOTFILES_DIR/.stowrc" ]; then
    echo "❌ Error: Run this script from your dotfiles directory or ensure it exists at $DOTFILES_DIR"
    exit 1
fi

cd "$DOTFILES_DIR"

# Install Homebrew first (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    if ! command -v brew &> /dev/null; then
        echo "📦 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for this session
        if [[ $(uname -m) == 'arm64' ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
fi

# Install Stow (needed for symlinking)
if ! command -v stow &> /dev/null; then
    echo "🔗 Installing Stow..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install stow
    else
        echo "❌ Please install GNU Stow manually on non-macOS systems"
        exit 1
    fi
fi

# Install packages from your Brewfile
if [ -f "Brewfile" ]; then
    echo "📦 Installing packages from your Brewfile..."
    brew bundle --no-lock
fi

# Create backup directory
echo "💾 Backing up existing dotfiles..."
backup_dir="$HOME/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$backup_dir"

# Function to backup and remove existing files/directories
backup_if_exists() {
    local target="$1"
    if [ -f "$HOME/$target" ] && [ ! -L "$HOME/$target" ]; then
        echo "  📄 Backing up $target"
        mv "$HOME/$target" "$backup_dir/"
    elif [ -d "$HOME/$target" ] && [ ! -L "$HOME/$target" ]; then
        echo "  📁 Backing up $target directory"
        mv "$HOME/$target" "$backup_dir/"
    elif [ -L "$HOME/$target" ]; then
        echo "  🔗 Removing existing symlink $target"
        rm "$HOME/$target"
    fi
}

# Backup your specific files
backup_if_exists ".gitconfig"
backup_if_exists ".zshrc"
backup_if_exists ".zshenv"
backup_if_exists ".zprofile"
backup_if_exists ".bashrc"
backup_if_exists ".profile"
backup_if_exists ".vimrc"
backup_if_exists ".vim"
backup_if_exists ".fzf.zsh"
backup_if_exists ".fzf.bash"

# Install Oh My Zsh if not already installed
install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "🐚 Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "🐚 Oh My Zsh already installed"
    fi
}

install_oh_my_zsh

# Create symlinks using Stow
echo "🔗 Creating symlinks with Stow..."

# Function to stow if directory exists and has content
stow_if_exists() {
    local dir="$1"
    if [ -d "$dir" ] && [ "$(ls -A $dir 2>/dev/null)" ]; then
        echo "  📦 Stowing $dir"
        stow "$dir"
    else
        echo "  ⏭️  Skipping $dir (empty or doesn't exist)"
    fi
}

# Stow all your configuration directories
stow_if_exists "git"
stow_if_exists "zsh"
stow_if_exists "bash"
stow_if_exists "vim"
stow_if_exists "ssh"
stow_if_exists "fzf"
stow_if_exists "misc"

# Handle .config directory specially
if [ -d "config" ] && [ "$(ls -A config 2>/dev/null)" ]; then
    echo "  📦 Setting up .config directory..."
    mkdir -p "$HOME/.config"
    for app_config in config/*/; do
        if [ -d "$app_config" ]; then
            app_name=$(basename "$app_config")
            echo "    🔗 Linking .config/$app_name"
            # Remove existing directory/symlink
            [ -e "$HOME/.config/$app_name" ] && rm -rf "$HOME/.config/$app_name"
            ln -sf "$DOTFILES_DIR/config/$app_name" "$HOME/.config/$app_name"
        fi
    done
fi

# Set up VS Code configuration
setup_vscode() {
    local vscode_user_dir="$HOME/Library/Application Support/Code/User"
    
    if [ -d "$vscode_user_dir" ] && [ -d "vscode" ]; then
        echo "🔗 Setting up VS Code configuration..."
        
        # Backup existing VS Code settings
        [ -f "$vscode_user_dir/settings.json" ] && cp "$vscode_user_dir/settings.json" "$backup_dir/vscode_settings.json"
        [ -f "$vscode_user_dir/keybindings.json" ] && cp "$vscode_user_dir/keybindings.json" "$backup_dir/vscode_keybindings.json"
        
        # Create symlinks
        [ -f "vscode/settings.json" ] && ln -sf "$DOTFILES_DIR/vscode/settings.json" "$vscode_user_dir/settings.json"
        [ -f "vscode/keybindings.json" ] && ln -sf "$DOTFILES_DIR/vscode/keybindings.json" "$vscode_user_dir/keybindings.json"
        
        # Handle user-settings if it exists
        if [ -d "vscode/user-settings" ]; then
            echo "  🔗 Linking additional VS Code user settings"
            ln -sf "$DOTFILES_DIR/vscode/user-settings" "$HOME/.vscode"
        fi
    fi
}

setup_vscode

# Install FZF if directory exists
install_fzf() {
    if [ -d "$HOME/.fzf" ]; then
        echo "🔍 FZF directory already exists, skipping installation"
    else
        echo "🔍 Installing FZF..."
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
    fi
}

# Only install FZF if we have fzf configs
[ -d "fzf" ] && install_fzf

# Set up Python environment with pyenv
setup_pyenv() {
    if [ -f "pyenv/version" ] || [ -f "pyenv/install-note.txt" ]; then
        if ! command -v pyenv &> /dev/null; then
            echo "🐍 Installing pyenv..."
            brew install pyenv
            
            # Add pyenv to shell
            echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc.temp
            echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc.temp
            echo 'eval "$(pyenv init -)"' >> ~/.zshrc.temp
            
            # Source for current session
            export PYENV_ROOT="$HOME/.pyenv"
            export PATH="$PYENV_ROOT/bin:$PATH"
            eval "$(pyenv init -)"
        fi
        
        if [ -f "pyenv/version" ]; then
            python_version=$(cat pyenv/version)
            echo "🐍 Installing Python $python_version with pyenv..."
            pyenv install "$python_version" || echo "⚠️  Python $python_version installation failed or already exists"
            pyenv global "$python_version"
        fi
    fi
}

setup_pyenv

# Set up Rust environment
setup_rust() {
    if [ -d "rust" ] || [ -f "rust/install-note.txt" ]; then
        if ! command -v rustc &> /dev/null; then
            echo "🦀 Installing Rust..."
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            source "$HOME/.cargo/env"
        fi
        
        if [ -f "rust/config.toml" ]; then
            echo "🦀 Setting up Cargo config..."
            mkdir -p "$HOME/.cargo"
            ln -sf "$DOTFILES_DIR/rust/config.toml" "$HOME/.cargo/config.toml"
        elif [ -f "rust/config" ]; then
            mkdir -p "$HOME/.cargo"
            ln -sf "$DOTFILES_DIR/rust/config" "$HOME/.cargo/config"
        fi
    fi
}

setup_rust

# Install VS Code extensions
install_vscode_extensions() {
    if command -v code &> /dev/null && [ -f "vscode/extensions.txt" ]; then
        echo "🔌 Installing VS Code extensions..."
        while IFS= read -r extension; do
            if [ -n "$extension" ] && [[ ! "$extension" =~ ^# ]]; then
                echo "  📦 Installing $extension"
                code --install-extension "$extension" --force
            fi
        done < vscode/extensions.txt
    fi
}

install_vscode_extensions

# Set up Ollama if needed
setup_ollama() {
    if [ -d "ollama" ] && ! command -v ollama &> /dev/null; then
        echo "🤖 Ollama configuration found - installing Ollama..."
        brew install ollama
        echo "💡 You'll need to re-download your AI models with 'ollama pull <model-name>'"
    fi
}

setup_ollama

# Set up shell (prefer zsh since you have oh-my-zsh)
setup_shell() {
    if command -v zsh &> /dev/null && [ "$SHELL" != "$(which zsh)" ]; then
        echo "🐚 Setting zsh as default shell..."
        
        # Add zsh to allowed shells if not already there
        zsh_path=$(which zsh)
        if ! grep -q "$zsh_path" /etc/shells; then
            echo "$zsh_path" | sudo tee -a /etc/shells
        fi
        
        # Change default shell
        chsh -s "$zsh_path"
        echo "  ✅ Default shell changed to zsh (restart terminal to take effect)"
    fi
}

setup_shell

# Create standard directories
echo "📁 Creating standard directories..."
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/Desktop/Screenshots"  # macOS screenshot location
mkdir -p "$HOME/code-stuff"  # You seem to have this

# Set up macOS defaults if script exists
if [[ "$OSTYPE" == "darwin"* ]] && [ -f "macos/defaults.sh" ]; then
    echo "🍎 Setting up macOS defaults..."
    chmod +x macos/defaults.sh
    ./macos/defaults.sh
fi

# Final shell configuration
echo "🔧 Final setup..."

# Merge any temporary shell additions
if [ -f ~/.zshrc.temp ]; then
    cat ~/.zshrc.temp >> ~/.zshrc
    rm ~/.zshrc.temp
fi

# Source the new shell configuration
if [ -n "$ZSH_VERSION" ] && [ -f "$HOME/.zshrc" ]; then
    echo "  🔄 Sourcing .zshrc"
    source "$HOME/.zshrc" || true  # Don't fail if there are issues
elif [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc" ]; then
    echo "  🔄 Sourcing .bashrc"  
    source "$HOME/.bashrc" || true
fi

echo ""
echo "✅ Dotfiles setup complete!"
echo ""
echo "📂 Backup created at: $backup_dir"
echo ""

# Show what was installed
echo "📦 Configuration modules installed:"
find . -maxdepth 1 -type d -not -path "." -not -path "./.git" | sort | sed 's|./|  ✅ |'

echo ""
echo "🎯 Your development environment includes:"
echo "  🐚 Zsh with Oh My Zsh"
echo "  📝 Vim with your custom configuration"
echo "  🔍 FZF fuzzy finder"
echo "  🐍 Python development (pyenv)"
echo "  🦀 Rust development (rustup/cargo)"
echo "  🤖 AI tools (Ollama)"
echo "  💻 VS Code with extensions"
echo "  📦 All your Homebrew packages"

echo ""
echo "🔄 RESTART YOUR TERMINAL for all changes to take effect"

echo ""
echo "💡 Next steps:"
echo "  1. Restart your terminal"
echo "  2. Verify everything works: zsh, vim, git, etc."
echo "  3. Re-download Ollama models if needed"
echo "  4. Customize any settings as needed"
echo "  5. Commit any personal changes to your repo"

echo ""
echo "🎉 Welcome to your synchronized development environment!"
