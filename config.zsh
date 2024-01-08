# load shared config with Bash
if [ -f ~/common-config.sh ]; then
  . "$HOME/common-config.sh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Skip only aliases defined in the directories.zsh lib file
# This defines an "ll" alias which overlaps with my own
zstyle ':omz:lib:directories' aliases no

. "$ZSH/oh-my-zsh.sh"

eval "$(starship init zsh)"
