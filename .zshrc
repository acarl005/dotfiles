# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins+=(zsh-syntax-highlighting colored-man-pages autojump fzf)
if [[ $TERM_PROGRAM != WarpTerminal ]]; then
  plugins+=(zsh-autosuggestions pip)
fi

. "$HOME/config.zsh"
