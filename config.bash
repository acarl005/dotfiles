# load shared config with Bash
if [ -f $HOME/common-config.sh ]; then
  . $HOME/common-config.sh
fi

# generate the prompt-escaped versions of the colors. this indicates which characters are not
# printed in order for the shell to correctly calculate the prompt character length
fg_bg_esc() {
  echo "\\[\\e[0;38;5;${1};48;5;${2}m\\]"
}
fg_esc() {
  echo "\\[\\e[0;38;5;${1};49;22m\\]"
}

# set back to normal
reset_esc='\[\e[0m\]'


[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [[ `uname -s` = Linux ]]; then
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
BREW_PREFIX=/usr/local
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

# custom completions
if [ -f ~/.bash_completions ]; then
  . ~/.bash_completions
fi

# PROMPT_COMMAND is a variable whose value is some code that gets evaluated each time the prompt awaits input
# PS1 is the variable for the prompt you see when terminal is awaiting input
# the echo uses an escape sequence to update the current tab name if the terminal supports multiple tabs
# the history part makes sure the history from all tabs gets saved to .bash_history after they are closed
PROMPT_COMMAND='EXIT_STAT=$?; echo -ne "\033]0;$(basename $(pwd))\007"; history -a; history -r; PS1="$(generate_prompt) ${reset_esc}";'
export PS2='... '

HISTSIZE=3000
HISTFILESIZE=100000

remove_parens() {
  EXPR=$(echo "$1" | xargs)
  echo "${EXPR:1:$((${#EXPR} - 2))}"
}

generate_prompt() {
  STATUS_BG=196
  STATUS_STR='✘ '
  if [[ $EXIT_STAT = 0 ]]; then
    STATUS_BG=40
    STATUS_STR='✓ '
  fi

  ENV_BG=27
  ENV_STR=
  if [[ $VIRTUAL_ENV ]]; then
    ENV_STR="$ENV_STR $(basename "$VIRTUAL_ENV") "
  elif [[ $CONDA_PROMPT_MODIFIER ]] && [[ $CONDA_PROMPT_MODIFIER != "(base) " ]]; then
    ENV_STR="$ENV_STR $(remove_parens "$CONDA_PROMPT_MODIFIER")"
  fi
  if [ ! -z $rvm_bin_path ]; then
    ENV_STR="$ENV_STR $RUBY_VERSION"
  fi
  if [ ! -z $SSH_TTY ]; then
    ENV_STR="$ENV_STR \u@\h"
  fi

  DIR_BG=54
  DIR_FG=255
  DIR_STR=
  # get working directory path and replace $HOME with ~
  WORK_DIR=`pwd | sed "s~^$HOME~\~~"`
  # use "read" to parse the slashes to an array
  IFS=' ' read -r -a DIR_ARR <<< `echo $WORK_DIR | sed 's~\([^$]\)/~\1 ~g'`
  ARR_LEN="${#DIR_ARR[@]}"
  # decide how many levels to show based on terminal width
  NUM_LEVELS_TO_SHOW=$(expr $(tput cols) / 25)
  START_VAL=`expr $ARR_LEN - $NUM_LEVELS_TO_SHOW`
  # make sure we don't try to show more levels than there actually are
  if [ $START_VAL -le 0 ]; then
    START_VAL=0
  else
    # show an ellipsis if we chopped some levels off
    DIR_STR=…
  fi
  # build up the string
  for ind in `seq $START_VAL $ARR_LEN`; do
    DIR_STR="$DIR_STR${DIR_ARR[$ind]}/"
  done
  # remove extra slashes at the end
  DIR_STR=`echo $DIR_STR | sed 's~/*$~~g'`
  # maybe there are no levels at all.. then we're in the root
  if [ -z $DIR_STR ]; then
    DIR_STR=/
  fi
  # change the colors when we aren't in the home directory, so we know the potential danger of deleting and editting things out here
  if [[ $(pwd) != "$HOME"* ]]; then
    DIR_BG=235
    DIR_FG=210
  fi

  GIT_BG=
  GIT_STR=
  if git rev-parse --git-dir > /dev/null 2>&1; then
    GIT_STR=$(__git_ps1 | sed 's/ (\(.*\))$/\1/')
    if [[ $(git diff) ]]; then
      GIT_BG=88
    elif [[ $(git status --short) ]]; then
      GIT_BG=130
    else
      GIT_BG=22
    fi
  fi

  PROMPT_STR="$(fg_bg_esc 16 $STATUS_BG)$STATUS_STR"
  if [ ! -z $ENV_STR ]; then
    PROMPT_STR="$PROMPT_STR$(fg_bg_esc $STATUS_BG $ENV_BG)$(fg_bg_esc 255 $ENV_BG)$ENV_STR  $(fg_bg_esc $ENV_BG $DIR_BG)"
  else
    PROMPT_STR="$PROMPT_STR$(fg_bg_esc $STATUS_BG $DIR_BG)"
  fi
  PROMPT_STR="$PROMPT_STR$(fg_bg_esc $DIR_FG $DIR_BG) $DIR_STR "
  if [ -z $GIT_STR ]; then
    PROMPT_STR="$PROMPT_STR$(fg_esc $DIR_BG)"
  else
    PROMPT_STR="$PROMPT_STR$(fg_bg_esc $DIR_BG $GIT_BG)$(fg_bg_esc 255 $GIT_BG) $GIT_STR $(fg_esc $GIT_BG)"
  fi
  echo $PROMPT_STR
}


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
