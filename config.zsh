# load shared config with Bash
if [ -f ~/common-config.sh ]; then
  . "$HOME/common-config.sh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

. "$ZSH/oh-my-zsh.sh"

eval "$(starship init zsh)"
