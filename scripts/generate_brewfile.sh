et -e

# Destination for Brewfile
DOTFILES_DIR="."
mkdir -p "$DOTFILES_DIR"

BREWFILE_PATH="$DOTFILES_DIR/Brewfile"

echo "🔍 Checking Homebrew installation..."

if ! command -v brew >/dev/null 2>&1; then
  echo "❌ Homebrew is not installed. Please install it first: https://brew.sh"
  exit 1
fi

echo "🍺 Generating Brewfile at $BREWFILE_PATH ..."
brew bundle dump --file="$BREWFILE_PATH" --force

echo "✅ Brewfile generated successfully."
