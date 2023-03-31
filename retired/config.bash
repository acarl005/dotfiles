# load shared config with Bash
if [ -f "$HOME/common-config.sh" ]; then
  . "$HOME/common-config.sh"
fi

[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f "$HOME/.fzf.bash" ] && source "$HOME/.fzf.bash"

eval "$(starship init bash)"

if [[ $(uname -s) = Linux ]]; then
  [ -f /usr/share/autojump/autojump.bash ] && . /usr/share/autojump/autojump.bash
  [ -f /usr/share/autojump/autojump.sh ] && . /usr/share/autojump/autojump.sh
else
  [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
fi


# enable programmable completion features (you don't need to enable this if it's already enabled in
# /etc/bash.bashrc or /etc/profile, but it's often commented out by default
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# Git autocomplete features (Linux)
if [ -f /usr/share/bash-completion/completions/git ]; then
  . /usr/share/bash-completion/completions/git
elif [ -f /etc/bash_completion.d/git ]; then
  . /etc/bash_completion.d/git
fi
if [ -f /usr/lib/git-core/git-sh-prompt ]; then
  . /usr/lib/git-core/git-sh-prompt
fi

# Git autocomplete features (MacOS)
BREW_PREFIX=$(brew --prefix)
if [ -f $BREW_PREFIX/etc/bash_completion ]; then
  . $BREW_PREFIX/etc/bash_completion
fi
if [ -f $BREW_PREFIX/etc/bash_completion.d/git-completion.bash ]; then
  . $BREW_PREFIX/etc/bash_completion.d/git-completion.bash
fi
if [ -f $BREW_PREFIX/etc/bash_completion.d/git-flow-completion.bash ]; then
  . $BREW_PREFIX/etc/bash_completion.d/git-flow-completion.bash
fi
if [ -f $BREW_PREFIX/etc/bash_completion.d/git-prompt.sh ]; then
  . $BREW_PREFIX/etc/bash_completion.d/git-prompt.sh
fi

HISTSIZE=3000
HISTFILESIZE=100000

# set some global Bash options that i like
shopt -s extglob # enable extended glob patterns
shopt -s no_empty_cmd_completion # don't try to autocomplete empty line
# these are only available on bash version >= 4
if [ ${BASH_VERSION:0:1} -ge 4 ]; then
  shopt -s autocd # if you type non-existent command, and it happens to be a dir name, cd into that dir
  shopt -s globstar # enable recursive glob patterns, e.g. **/*.js
fi

# write the zsh commands for going up directories by typing a number of dots
DOTS=..
ARG=..
for i in `seq 1 11`; do
  alias $DOTS="cd $ARG"
  DOTS="${DOTS}."
  ARG="${ARG}/.."
done
