# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins+=(zsh-syntax-highlighting colored-man-pages autojump)

if [[ $TERM_PROGRAM != WarpTerminal ]]; then
  plugins+=(zsh-autosuggestions zsh-vi-mode pip)

. "$HOME/config.zsh"
