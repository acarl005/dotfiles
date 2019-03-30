# function for generating escaped color codes
fg_bg_esc() {
  echo "\\[\\e[0;38;5;${1};48;5;${2}m\\]"
}
fg_esc() {
  echo "\\[\\e[0;38;5;${1};49;22m\\]"
}

# set back to normal
reset_esc='\[\e[0m\]'

# generate the right ANSI escape sequences for the 256 color codes (foreground and background)
forg() {
  echo "\\033[38;5;${1}m"
}
backg() {
  echo "\\033[48;5;${1}m"
}
# set color back to normal
reset='\033[0m'

# print a message if a dependency is missing
suggest() {
  # but only print if interactive
  if [[ $- =~ "i" ]]; then
    echo -e "$(backg 52)You can \033[4menhance\033[24m the experience by installing $(forg 51)$1$reset$(backg 52). Install here $(forg 199)$2$reset."
  fi
}

if [[ $- =~ "i" ]]; then
  if command -v neofetch >/dev/null; then
    neofetch
  else
    # Greet me with a mario and other stuff
    echo
    echo -e "[48;5;m          [0m[48;5;9m          [0m[48;5;m    [0m[48;5;224m      [0m[48;5;m  [0m\
      $(forg 227)username: $(forg 33)$USER"
    echo -e "[48;5;m        [0m[48;5;9m                  [0m[48;5;224m    [0m[48;5;m  [0m\
      $(forg 227)date: $(forg 33)$(date)"
    echo -e "[48;5;m        [0m[48;5;95m      [0m[48;5;224m    [0m[48;5;0m  [0m[48;5;224m  [0m[48;5;m  [0m[48;5;9m      [0m[48;5;m  [0m\
      $(forg 227)hostname: $(forg 33)$HOSTNAME"
    echo -e "[48;5;m      [0m[48;5;95m  [0m[48;5;224m  [0m[48;5;95m  [0m[48;5;224m      [0m[48;5;0m  [0m[48;5;224m      [0m[48;5;9m    [0m[48;5;m  [0m\
      $(forg 227)kernel: $(forg 33)$OSTYPE"
    echo -e "[48;5;m      [0m[48;5;95m  [0m[48;5;224m  [0m[48;5;95m    [0m[48;5;224m      [0m[48;5;95m  [0m[48;5;224m      [0m[48;5;9m  [0m[48;5;m  [0m"
    echo -e "[48;5;m      [0m[48;5;95m    [0m[48;5;224m        [0m[48;5;95m        [0m[48;5;9m  [0m[48;5;m    [0m"
    echo -e "[48;5;m          [0m[48;5;224m              [0m[48;5;9m    [0m[48;5;m    [0m"
    echo -e "[48;5;m    [0m[48;5;9m        [0m[48;5;33m  [0m[48;5;9m      [0m[48;5;33m  [0m[48;5;9m    [0m[48;5;m    [0m[48;5;95m  [0m"
    echo -e "[48;5;224m    [0m[48;5;9m          [0m[48;5;33m  [0m[48;5;9m      [0m[48;5;33m  [0m[48;5;m    [0m[48;5;95m    [0m"
    echo -e "[48;5;224m      [0m[48;5;9m        [0m[48;5;33m        [0m[48;5;11m  [0m[48;5;33m    [0m[48;5;95m    [0m"
    echo -e "[48;5;m  [0m[48;5;224m  [0m[48;5;m    [0m[48;5;33m  [0m[48;5;9m  [0m[48;5;33m    [0m[48;5;11m  [0m[48;5;33m          [0m[48;5;95m    [0m"
    echo -e "[48;5;m    [0m[48;5;95m      [0m[48;5;33m                  [0m[48;5;95m    [0m"
    echo -e "[48;5;m  [0m[48;5;95m      [0m[48;5;33m            [0m[48;5;m            [0m"
    echo -e "[48;5;m  [0m[48;5;95m    [0m[48;5;m                          [0m"
    echo
    suggest neofetch https://github.com/dylanaraps/neofetch
  fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/.cargo/bin" ]; then
  PATH="$HOME/.cargo/bin:$PATH"
  export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/src"
fi


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && {
  . "$NVM_DIR/nvm.sh"  # This loads nvm
  export NODE_PATH="$HOME/.nvm/versions/node/$(node -v)/lib/node_modules"
}

# include Golang stuff
if [ -d "$HOME/go" ]; then
  export GOPATH="$HOME/go"
  PATH="$GOPATH/bin:$PATH"
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# use the version of Git i installed with homebrew instead of the one that came with the OS
if brew --prefix git >/dev/null 2>&1; then
  PATH="$(brew --prefix git)/bin:$PATH"
fi

# Load git completions
git_completion_script=/usr/local/etc/bash_completion.d/git-completion.bash
git_prompt_script=/usr/local/etc/bash_completion.d/git-prompt.sh
test -s $git_completion_script && source $git_completion_script
test -s $git_prompt_script && source $git_prompt_script

git_completion_script=~/git-completion.bash
git_prompt_script=~/git-prompt.sh
test -s $git_completion_script && source $git_completion_script
test -s $git_prompt_script && source $git_prompt_script

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


# PROMPT_COMMAND is a variable whose value is some code that gets evaluated each time the prompt awaits input
# PS1 is the variable for the prompt you see when terminal is awaiting input
# the echo uses an escape sequence to update the current tab name if the terminal supports multiple tabs
# the history part makes sure the history from all tabs gets saved to .bash_history after they are closed
PROMPT_COMMAND='EXIT_STAT=$?; echo -ne "\033]0;$(basename $(pwd))\007"; history -a; history -r; PS1="$(generate_prompt) ${reset_esc}";'
export PS2='... '

HISTSIZE=3000

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
    ENV_STR="$ENV_STR $(basename $VIRTUAL_ENV) "
  elif [[ $CONDA_PREFIX ]]; then
    ENV_STR="$ENV_STR $(basename $CONDA_PREFIX)"
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



# Colors ls should use for folders, files, symlinks etc, see `man ls` and
# search for LSCOLORS
export LSCOLORS=ExGxFxdxCxDxDxaccxaeex
export LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=33:ex=1;32:bd=1;33:cd=1;33:su=30;42:sg=32:tw=30;44:ow=34'

# Force grep to always use the color option and show line numbers
export GREP_OPTIONS='--color=auto'


# Set vim as the default editor
export EDITOR=vim

if command -v ls-go >/dev/null; then
  alias ll='ls-go -alLRkSn'
else
  suggest ls-go https://github.com/acarl005/ls-go
  if [[ `uname -s` = Linux ]]; then
    alias ll='/bin/ls -FlAhp --color=auto'
  else
    alias ll='/bin/ls -FGlAhp'
  fi
fi

# Alias definitions.
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# custom completions
if [ -f ~/.bash_completions ]; then
  . ~/.bash_completions
fi

cd() { builtin cd "$@" && printf "\033c" && ll; }
pushd() { builtin pushd "$@" && printf "\033c"; ll; }
mkcd() { mkdir -p "$1" && cd "$1"; }

# enable colorful man pages
man() {
  LESS_TERMCAP_md=$'\e[01;31m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[01;44;33m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[01;32m' \
  command man "$@"
}

if command -v pygmentize >/dev/null; then
  export LESSOPEN="| pygmentize %s"
  export LESS=" -R" 
  # overwrite cat command so that it uses pygments instead
  cat() {
    # only use color if the stdout points to the terminal
    if [ -t 1 ]; then
      pygmentize "$@" 2>/dev/null # silence errors
      [[ $? != 0 ]] && /bin/cat "$@" # if an error occurs, fall back to the regular cat
    # otherwise, if we're piping to another command, we dont want the color
    else
      /bin/cat "$@"
    fi
  }
else
  suggest pygments http://pygments.org/download/
fi

local-install() {
  npm install $(npm pack "$1" | tail -1)
}

docker-kill() {
  docker rm $(docker ps -a -q)
}

docker-clean() {
  docker rmi $(docker images -q)
}

# set some global bash options that i like
shopt -s extglob # enable extended glob patterns
shopt -s no_empty_cmd_completion # don't try to autocomplete empty line
# these are only available on bash version >= 4
if [ ${BASH_VERSION:0:1} -ge 4 ]; then
  shopt -s autocd # if you type non-existent command, and it happens to be a dir name, cd into that dir
  shopt -s globstar # enable recursive glob patterns, e.g. **/*.js
fi

#extract most known archives
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.xz)    tar xvfJ $1    ;;
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)     echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


##############
# NETWORKING #
##############

alias myip='dig +short myip.opendns.com @resolver1.opendns.com'  # myip:         Public facing IP Address
alias netCons='lsof -i'                                          # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'                         # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'                          # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'                # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'                # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'                           # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'                           # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'                     # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                               # showBlocked:  All ipfw rules inc/ blocked IPs
listening() {
  lsof -n -i4TCP:$1 | grep LISTEN
}

# load a config file for the python REPL
export PYTHONSTARTUP=$HOME/.pythonrc.py


####################
# disposable stuff #
####################

if command -v java >/dev/null; then
  if [[ `uname -s` = Linux ]]; then
    export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
  else
    UNUSED=$(/usr/libexec/java_home 2>/dev/null)
    if [[ $? -eq 0 ]]; then
      export JAVA_HOME=$(/usr/libexec/java_home)
    fi
  fi
fi

if [[ `uname -s` = Linux ]]; then
  [ -f /usr/share/autojump/autojump.bash ] && . /usr/share/autojump/autojump.bash
  [ -f /usr/share/autojump/autojump.sh ] && . /usr/share/autojump/autojump.sh
else
  [ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh
fi

