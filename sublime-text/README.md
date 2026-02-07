# Sublime Text Configuration

A comprehensive Sublime Text setup optimized for Python development with Catppuccin theme, language servers, linters, and autocomplete.

## Features

### Theme & Appearance
- **Catppuccin Mocha** color scheme and theme
- **JetBrains Mono Nerd Font** for better readability and icon support
- Line highlighting and relative line numbers
- Minimap with border and viewport

### Python Development
- **LSP-Pyright**: Microsoft's Python language server for type checking and intelligent autocomplete
- **LSP-Ruff**: Fast linting and formatting with Ruff
- **Type Checking**: Real-time type checking with mypy and Pyright
- **Auto-formatting**: Black formatter (88 character line length)
- **Linting**: Flake8 and Ruff for code quality
- **Code Intelligence**: Jedi-based autocompletion and SublimeCodeIntel

### Editor Features
- Auto-save on focus lost
- Trim trailing whitespace on save
- Format on save with LSP
- Auto-organize imports
- PEP 8 compliance (88 character ruler for Black)
- Smart indentation (4 spaces for Python)
- Enhanced bracket highlighting
- Git gutter integration

## Installation

### Automatic Installation (Recommended)

Run the main dotfiles installation script:

```bash
./install.sh
```

This will:
1. Install Sublime Text via Homebrew
2. Install all Python development tools (ruff, black, mypy, flake8, pyright)
3. Symlink the configuration files to the correct location

### Manual Installation

1. Install Sublime Text:
   ```bash
   brew install --cask sublime-text
   ```

2. Install Python development tools:
   ```bash
   brew install ruff black mypy flake8 pyright
   ```

3. Symlink the configuration:
   ```bash
   stow -t "$HOME" sublime-text
   ```

### Post-Installation Setup

1. **Install Package Control**:
   - Open Sublime Text
   - Press `Cmd+Shift+P` to open the Command Palette
   - Type "Install Package Control" and press Enter
   - Wait for the installation to complete

2. **Install Packages**:
   - After Package Control is installed, it will automatically install all packages listed in `Package Control.sublime-settings`
   - This may take a few minutes
   - Restart Sublime Text after installation completes

3. **Install Catppuccin Theme**:
   - The Catppuccin package should be auto-installed via Package Control
   - If not, press `Cmd+Shift+P`, type "Package Control: Install Package"
   - Search for "Catppuccin" and install it

4. **Verify LSP Setup**:
   - Open a Python file
   - You should see type hints, autocomplete, and linting working
   - If not, press `Cmd+Shift+P` and type "LSP: Enable Language Server"

## Python Tools Configuration

### Pyright (Type Checking)
- Type checking mode: `basic` (configurable to `strict` in LSP.sublime-settings)
- Auto-import completions enabled
- Inlay hints for function returns, variable types, and parameters

### Ruff (Linting & Formatting)
- All rules enabled by default (can be customized per project)
- Ignores pydocstyle and annotation rules by default
- Auto-fix violations on save
- Organize imports on save

### Black (Formatting)
- 88 character line length (PEP 8 compliant)
- Automatic formatting on save

## Key Bindings

Sublime Text uses standard key bindings. Here are some useful ones:

- `Cmd+Shift+P`: Command Palette
- `Cmd+P`: Quick file switch
- `Cmd+Shift+F`: Find in project
- `Cmd+/`: Toggle comment
- `Cmd+D`: Select next occurrence
- `Ctrl+Space`: Trigger autocomplete
- `F12`: Go to definition
- `Cmd+Shift+R`: Go to symbol
- `Cmd+.`: Show code actions (LSP)

## Customization

### Per-Project Settings

Create a `.sublime-project` file in your project root:

```json
{
    "folders": [
        {
            "path": "."
        }
    ],
    "settings": {
        "LSP": {
            "pyright": {
                "settings": {
                    "python.analysis.typeCheckingMode": "strict"
                }
            }
        }
    }
}
```

### Python Virtual Environments

LSP will automatically detect and use virtual environments in your project:
- `.venv/`
- `venv/`
- `env/`

### Adjusting Type Checking Strictness

Edit `LSP.sublime-settings` and change:
```json
"python.analysis.typeCheckingMode": "basic"
```

Options: `"off"`, `"basic"`, `"strict"`

## Troubleshooting

### LSP Not Working

1. Check if language servers are installed:
   ```bash
   which pyright
   which ruff
   ```

2. View LSP logs:
   - `Cmd+Shift+P` → "LSP: Toggle Log Panel"

3. Restart LSP servers:
   - `Cmd+Shift+P` → "LSP: Restart Servers"

### Package Control Not Installing Packages

1. Check Package Control logs:
   - `Cmd+Shift+P` → "Package Control: List Packages"
   - View → Show Console

2. Manually install missing packages:
   - `Cmd+Shift+P` → "Package Control: Install Package"

### Theme Not Applied

1. Restart Sublime Text
2. Manually select theme:
   - `Cmd+Shift+P` → "UI: Select Theme"
   - Choose "Catppuccin Mocha"

## Files Structure

```
sublime-text/
└── Library/
    └── Application Support/
        └── Sublime Text/
            └── Packages/
                └── User/
                    ├── Preferences.sublime-settings       # Main settings
                    ├── Package Control.sublime-settings  # Installed packages
                    ├── LSP.sublime-settings              # Language server config
                    └── Python.sublime-settings           # Python-specific settings
```

## Additional Resources

- [Sublime Text Documentation](https://www.sublimetext.com/docs/)
- [LSP Documentation](https://lsp.sublimetext.io/)
- [Catppuccin Theme](https://github.com/catppuccin/catppuccin)
- [Pyright Documentation](https://github.com/microsoft/pyright)
- [Ruff Documentation](https://docs.astral.sh/ruff/)
