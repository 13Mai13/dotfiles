# =======================================
# Oh My Zsh Configuration
# =======================================

# Path to your Oh My Zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme (see: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes)
ZSH_THEME="robbyrussell"

# Plugins (add more as needed)
plugins=(git)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh


# =======================================
# Extra Tooling
# =======================================

# Starship Prompt (https://starship.rs/)
eval "$(starship init zsh)"

# fzf (Fuzzy Finder - https://github.com/junegunn/fzf)
eval "$(fzf --zsh)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# uv
export PATH="$HOME/.local/bin:$PATH"


# =======================================
# SSH Key Management
# =======================================

# Start ssh-agent if not already running
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  eval "$(ssh-agent -s)"
fi

# Add GitLab (work) SSH key
if ! ssh-add -l | grep -q 'id_ed25519'; then
  ssh-add --apple-use-keychain ~/.ssh/id_ed25519 &>/dev/null
fi

# Add GitHub (personal) SSH key
if [ -f ~/.ssh/id_ed25519_github ]; then
  if ! ssh-add -l | grep -q 'id_ed25519_github'; then
    ssh-add --apple-use-keychain ~/.ssh/id_ed25519_github &>/dev/null
  fi
fi
