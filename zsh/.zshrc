# Zsh Configuration

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

# Enable completion
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Enable colors
autoload -U colors && colors

# FZF integration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND='find . -type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Starship prompt
eval "$(starship init zsh)"

# SSH Agent - load keys once per session
ssh-add --apple-load-keychain &>/dev/null

# ngrok shell completions
if command -v ngrok &>/dev/null; then
  eval "$(ngrok completion)"
fi

# Aliases
alias ll='ls -lah'
alias vim='nvim'
alias v='nvim'
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph'
alias gd='git diff'

# Python/UV aliases
alias py='python3'
alias uvr='uv run'
alias uvs='uv sync'

# Docker/Colima aliases
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'

# Directory navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Quick directory jumps (customize these for your needs)
alias code='cd ~/code'
alias code-mai='cd ~/.mai_code'
alias dots='cd ~/.dotfiles'

# Load local customizations if they exist
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
