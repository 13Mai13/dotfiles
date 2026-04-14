# Obsidian Configuration

This directory contains Obsidian configuration files that are synced across machines.

## Required Plugins

Install these community plugins in Obsidian:
- **Style Settings** - Allows customization of theme settings
- **Icon Folder** - Adds icons to folders
- **Excalidraw** - Drawing and diagramming
- **Code Styler** - Enhanced code block styling

## Required Theme

- **Minimal** - Install from Obsidian's community themes
  - Repository: https://github.com/kepano/obsidian-minimal
  - Configured with Notion-inspired color scheme

## Setup

The install script will automatically symlink these config files to your Obsidian vault.

### Manual Setup

If you need to set up manually:

```bash
# Create vault directory if it doesn't exist
mkdir -p ~/.mai_code/mai-notes/.obsidian/plugins/obsidian-style-settings

# Symlink config files
ln -sf ~/.mai_code/dotfiles/obsidian/.obsidian/appearance.json ~/.mai_code/mai-notes/.obsidian/
ln -sf ~/.mai_code/dotfiles/obsidian/.obsidian/community-plugins.json ~/.mai_code/mai-notes/.obsidian/
ln -sf ~/.mai_code/dotfiles/obsidian/.obsidian/core-plugins.json ~/.mai_code/mai-notes/.obsidian/
ln -sf ~/.mai_code/dotfiles/obsidian/.obsidian/hotkeys.json ~/.mai_code/mai-notes/.obsidian/
ln -sf ~/.mai_code/dotfiles/obsidian/.obsidian/templates.json ~/.mai_code/mai-notes/.obsidian/
ln -sf ~/.mai_code/dotfiles/obsidian/.obsidian/plugins/obsidian-style-settings/data.json ~/.mai_code/mai-notes/.obsidian/plugins/obsidian-style-settings/
```

## Notes

- Themes and plugins themselves are not synced (they're too large and version-specific)
- Only configuration files are synced
- After setting up a new machine, you'll need to install the plugins and themes through Obsidian
- The Style Settings will automatically apply once the plugin is installed
