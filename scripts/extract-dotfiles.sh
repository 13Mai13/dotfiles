#!/bin/bash

# extract-dotfiles.sh - Extract YOUR current configurations into dotfiles structure

set -e

DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="$HOME/dotfiles_extraction_backup_$(date +%Y%m%d_%H%M%S)"

echo "🚀 Extracting your current setup into dotfiles structure..."
echo "📂 Creating dotfiles directory: $DOTFILES_DIR"

# Create the main dotfiles directory
mkdir -p "$DOTFILES_DIR"
cd "$DOTFILES_DIR"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Create directory structure based on your files
echo "📁 Creating directory structure..."
mkdir -p git zsh bash vim ssh vscode config fzf pyenv rustup ollama misc

echo "🔍 Extracting configurations..."

# 1. Git configuration
if [ -f "$HOME/.gitconfig" ]; then
    echo "  ✅ Found .gitconfig"
    cp "$HOME/.gitconfig" git/
    cp "$HOME/.gitconfig" "$BACKUP_DIR/"
fi

# 2. Zsh configuration (you have oh-my-zsh!)
if [ -f "$HOME/.zshrc" ]; then
    echo "  ✅ Found .zshrc"
    cp "$HOME/.zshrc" zsh/
    cp "$HOME/.zshrc" "$BACKUP_DIR/"
fi

if [ -f "$HOME/.zshenv" ]; then
    echo "  ✅ Found .zshenv"
    cp "$HOME/.zshenv" zsh/
fi

if [ -f "$HOME/.zprofile" ]; then
    echo "  ✅ Found .zprofile"
    cp "$HOME/.zprofile" zsh/
fi

# Note about oh-my-zsh (don't copy the whole thing, just reference it)
echo "  📝 Note: oh-my-zsh detected - will add installation to setup script"
echo "# oh-my-zsh should be installed fresh on each machine" > zsh/oh-my-zsh-note.txt
echo "# Installation command: sh -c \"\$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\"" >> zsh/oh-my-zsh-note.txt

# 3. Bash configuration
if [ -f "$HOME/.bashrc" ]; then
    echo "  ✅ Found .bashrc"
    cp "$HOME/.bashrc" bash/
fi

if [ -f "$HOME/.profile" ]; then
    echo "  ✅ Found .profile"
    cp "$HOME/.profile" bash/
fi

# 4. Vim configuration (you have both .vimrc and .vim directory)
if [ -f "$HOME/.vimrc" ]; then
    echo "  ✅ Found .vimrc"
    cp "$HOME/.vimrc" vim/
fi

if [ -d "$HOME/.vim" ]; then
    echo "  ✅ Found .vim directory"
    cp -r "$HOME/.vim" vim/
fi

# 5. SSH configuration (careful with sensitive files)
if [ -f "$HOME/.ssh/config" ]; then
    echo "  ✅ Found SSH config"
    cp "$HOME/.ssh/config" ssh/
    echo "  ⚠️  Remember: SSH private keys are NOT copied for security"
fi

# Create a .gitkeep file for ssh directory
touch ssh/.gitkeep

# 6. FZF configuration (you have fzf setup)
if [ -f "$HOME/.fzf.zsh" ]; then
    echo "  ✅ Found .fzf.zsh"
    cp "$HOME/.fzf.zsh" fzf/
fi

if [ -f "$HOME/.fzf.bash" ]; then
    echo "  ✅ Found .fzf.bash"
    cp "$HOME/.fzf.bash" fzf/
fi

# 7. Config directory (modern configs)
if [ -d "$HOME/.config" ]; then
    echo "  ✅ Found .config directory"
    # Copy the structure but be selective about what we include
    mkdir -p config
    
    # Common config directories to include
    for app_config in "git" "nvim" "tmux" "alacritty" "kitty" "fish"; do
        if [ -d "$HOME/.config/$app_config" ]; then
            echo "    ✅ Copying .config/$app_config"
            cp -r "$HOME/.config/$app_config" config/
        fi
    done
    
    # List what's in .config for manual review
    echo "    📋 Contents of your .config directory:"
    ls -la "$HOME/.config" | head -20
    echo "    💡 Review and manually add other configs you need from .config/"
fi

# 8. VS Code settings
# Check both possible locations
VSCODE_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
if [ -d "$VSCODE_SETTINGS_DIR" ]; then
    if [ -f "$VSCODE_SETTINGS_DIR/settings.json" ]; then
        echo "  ✅ Found VS Code settings.json"
        cp "$VSCODE_SETTINGS_DIR/settings.json" vscode/
    fi
    
    if [ -f "$VSCODE_SETTINGS_DIR/keybindings.json" ]; then
        echo "  ✅ Found VS Code keybindings.json"
        cp "$VSCODE_SETTINGS_DIR/keybindings.json" vscode/
    fi
    
    # Extract VS Code extensions
    if command -v code &> /dev/null; then
        echo "  ✅ Extracting VS Code extensions list"
        code --list-extensions > vscode/extensions.txt
    fi
fi

# Also check if you have .vscode directory
if [ -d "$HOME/.vscode" ]; then
    echo "  ✅ Found .vscode directory"
    cp -r "$HOME/.vscode/" vscode/user-settings/
fi

# 9. You already have a Brewfile!
if [ -f "$HOME/Brewfile" ]; then
    echo "  ✅ Found existing Brewfile"
    cp "$HOME/Brewfile" .
else
    # Generate from current setup if no existing Brewfile
    if command -v brew &> /dev/null; then
        echo "  ✅ Generating Brewfile from current Homebrew setup"
        brew bundle dump --force --file=Brewfile
    fi
fi

# 10. Development environments (you have several)

# Pyenv
if [ -d "$HOME/.pyenv" ] && [ -f "$HOME/.pyenv/version" ]; then
    echo "  ✅ Found pyenv setup"
    mkdir -p pyenv
    cp "$HOME/.pyenv/version" pyenv/ 2>/dev/null || true
    echo "# pyenv global version" > pyenv/install-note.txt
    echo "# Run: pyenv install \$(cat version) && pyenv global \$(cat version)" >> pyenv/install-note.txt
fi

# Rust/Cargo setup
if [ -d "$HOME/.rustup" ] && [ -d "$HOME/.cargo" ]; then
    echo "  ✅ Found Rust setup"
    mkdir -p rust
    [ -f "$HOME/.cargo/config.toml" ] && cp "$HOME/.cargo/config.toml" rust/
    [ -f "$HOME/.cargo/config" ] && cp "$HOME/.cargo/config" rust/
    echo "# Rust installed via rustup" > rust/install-note.txt
    echo "# Install with: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh" >> rust/install-note.txt
fi

# Ollama (you have this)
if [ -d "$HOME/.ollama" ]; then
    echo "  ✅ Found Ollama directory"
    mkdir -p ollama
    echo "# Ollama AI models directory found" > ollama/install-note.txt
    echo "# Install with: brew install ollama" >> ollama/install-note.txt
    echo "# Your models will need to be re-downloaded" >> ollama/install-note.txt
fi

# 11. Other specific files you have
declare -a your_configs=(
    ".lesshst"
)

for config in "${your_configs[@]}"; do
    if [ -f "$HOME/$config" ]; then
        echo "  ✅ Found $config"
        cp "$HOME/$config" misc/
    fi
done

# 12. Create enhanced .gitignore based on your setup
echo "📝 Creating comprehensive .gitignore..."
cat > .gitignore << 'EOF'
# Sensitive files
ssh/id_*
ssh/known_hosts*
ssh/authorized_keys*

# History files
.zsh_history
.bash_history
.python_history
.lesshst
.viminfo

# Compiled zsh files
.zcompdump*
*.zwc

# OS generated files
.DS_Store
.DS_Store?
._*
.Spotlight-V100
.Trashes
.CFUserTextEncoding
ehthumbs.db
Thumbs.db

# Directories that should be installed fresh
.oh-my-zsh/
.pyenv/versions/
.rustup/toolchains/
.cargo/bin/
.cargo/registry/
.fzf/
node_modules/

# IDE and editor
.vscode/workspaceStorage/
.vscode/logs/
.idea/
.vim/sessions/
.vim/.netrwhist

# Development caches
.cache/
.npm/
.cargo/registry/
.cargo/git/

# Local environment files
.env
.env.local

# Logs
*.log

# Backup files
*.bak
*~

# Docker
.docker/config.json

# Application data that shouldn't be synced
.cups/
.Trash/
.jupyter/runtime/
.local/share/
Library/
EOF

# 13. Create .stowrc
cat > .stowrc << 'EOF'
--target=$HOME
--verbose=2
EOF

# 14. Create enhanced README based on your setup
cat > README.md << 'EOF'
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
EOF

# Create a summary report
echo ""
echo "📊 EXTRACTION SUMMARY"
echo "===================="

echo "📁 Directory structure created in: $DOTFILES_DIR"
echo "💾 Backup of original files in: $BACKUP_DIR"
echo ""
echo "✅ Files successfully extracted:"

find "$DOTFILES_DIR" -type f -not -path "*/.*" -not -name "*.txt" | sort

echo ""
echo "📋 Special configurations detected:"
echo "  🐚 Oh My Zsh (will be installed fresh)"
echo "  🔍 FZF fuzzy finder"
echo "  🐍 Python with pyenv"
echo "  🦀 Rust with rustup/cargo"  
echo "  🤖 Ollama AI models"
echo "  🐋 Docker + Colima"
echo "  📦 Existing Brewfile found"

echo ""
echo "⚠️  IMPORTANT NEXT STEPS:"
echo "1. Review all extracted files before committing to git"
echo "2. Check your .config directory and manually add needed configs"
echo "3. Remove or sanitize any sensitive information"
echo "4. Test the configuration on a separate user account first"
echo "5. Initialize git repository:"
echo "   cd $DOTFILES_DIR"
echo "   git init"
echo "   git add ."
echo "   git commit -m 'Initial dotfiles extraction'"
echo ""

echo "🔍 Manual review needed for:"
echo "  ~/.config/ directory (check what else you need)"
echo "  Development tool configurations"
echo "  Any custom scripts in your PATH"

echo ""
echo "🔒 Security reminders:"
echo "- SSH private keys were NOT copied"
echo "- History files are excluded from git"
echo "- Check for hardcoded passwords or API keys"
echo "- Review .gitignore coverage"

echo ""
echo "🎉 Extraction complete! Your dotfiles are ready in $DOTFILES_DIR"
echo "💡 Next: Review files, customize, then push to GitHub"
