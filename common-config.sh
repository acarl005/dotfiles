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

set -o vi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ]; then
  PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ]; then
  PATH="$HOME/.local/bin:$PATH"
fi
if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

# include Golang stuff
if [ -d "$HOME/go" ]; then
  export GOPATH="$HOME/go"
  PATH="$GOPATH/bin:$PATH"
fi

if command -v brew >/dev/null; then
  eval "$(brew shellenv)"
fi

# if this is an interactive shell
if [[ $- =~ "i" ]]; then
  if [ -d .git ] && command -v onefetch >/dev/null; then
    onefetch
  elif command -v neofetch >/dev/null; then
    neofetch
  elif command -v pfetch >/dev/null; then
    # I disabled "packages"
    export PF_INFO="ascii title os host kernel uptime memory shell editor wm de palette"
    pfetch
  else
    suggest neofetch https://github.com/dylanaraps/neofetch
  fi
fi


# Set vim as the default editor, or NeoVim if its installed
export EDITOR=vim
export VISUAL=vim
alias vimd=vimdiff
alias v=vim
if command -v nvim >/dev/null; then
  export EDITOR=nvim
  export VISUAL=nvim
  alias v=nvim
  alias vi=nvim
  alias vim=nvim
  alias vimdiff='nvim -d'
  alias vimd='nvim -d'
fi

export PAGER='less -S'

# Colors ls should use for folders, files, symlinks etc, see `man ls` and
# search for LSCOLORS
export LSCOLORS=ExGxFxdxCxDxDxaccxaeex
export LS_COLORS='di=1;34:ln=1;36:so=1;35:pi=33:ex=1;32:bd=1;33:cd=1;33:su=30;42:sg=32:tw=30;44:ow=34'

if command -v ls-go >/dev/null; then
  alias ll='ls-go -alLkn'
else
  suggest ls-go https://github.com/acarl005/ls-go
  if [[ `uname -s` = Linux ]]; then
    alias ll='command -p ls -FlAhp --color=auto'
  else
    alias ll='command -p ls -FGlAhp'
  fi
fi

cd() { builtin cd "$@" && printf "\033c" && ll; }
pushd() { builtin pushd "$@" && printf "\033c"; ll; }
mkcd() { mkdir -p "$1" && cd "$1"; }

# enable colorful man pages
# md      start bold
# me      turn off bold, blink and underline
# so      start standout
# se      stop standout
# us      start underline
# ue      stop underline
man() {
  LESS_TERMCAP_md=$'\e[01;31m' \
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_so=$'\e[01;44;33m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_us=$'\e[01;32m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  command man "$@"
}


# extract most known archives
extract() (
  if [ -f "$1" ] ; then
    set -x
    case $1 in
      *.tar.xz)    tar xfJ "$1"     ;;
      *.tar.bz2)   tar xjf "$1"     ;;
      *.tar.gz)    tar xzf "$1"     ;;
      *.bz2)       bunzip2 "$1"     ;;
      *.rar)       unrar e "$1"     ;;
      *.gz)        gunzip "$1"      ;;
      *.tar)       tar xf "$1"      ;;
      *.tbz2)      tar xjf "$1"     ;;
      *.tgz)       tar xzf "$1"     ;;
      *.zip)       unzip "$1"       ;;
      *.Z)         uncompress "$1"  ;;
      *.7z)        7z x "$1"        ;;
      *)     echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
)

csv_less() {
  sed -e "s/^,/␀,/" -e "s/,,/,␀,/g" -e "s/,$/,␀/" $1 | sed -e "s/,,/,␀,/g" | column -s, -t | less -#2 -N -S
}

hl() {
  grep --color -E "$1|$" "${@:2}"
}

root() {
  builtin cd "$(git root)"
  if [ -d .git ] && command -v onefetch >/dev/null; then
    onefetch
  fi
  ll
}

cheat() {
  curl "cheat.sh/$1"
}

if command -v yazi >/dev/null; then
  function ya() {
    tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    yazi --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
      cd -- "$cwd"
    fi
    rm -f -- "$tmp"
  }
fi

# Aliases
alias f='fortune | cowsay -f tux'
alias pony='fortune | ponysay -b round'
alias grep='grep --exclude-dir=node_modules --color=auto'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias chx='chmod +x'
if [[ $(uname -s) = Linux ]]; then
  alias ls='ls -p --color=auto'
else
  alias ls='ls -Gp'
fi
alias less='less -XmiJ'
alias rn='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
# force tmux to use utf8 encoding so emojis and stuff render
alias tmux='tmux -u'
# https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '
alias cwd='pwd | tr -d "\n" | pbcopy'


# full recursive directory listing
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'


if command -v batcat >/dev/null; then
  alias bat=batcat
fi

# jump to commonly used directories
alias desk="pushd $HOME/Desktop"
export desk="$HOME/Desktop"
alias proj="pushd $HOME/Documents/projects"
export proj="$HOME/Documents/projects"
alias down="pushd $HOME/Downloads"
export down="$HOME/Downloads"
alias docs="pushd $HOME/Documents"
export docs="$HOME/Documents"
alias pg="/usr/local/var/postgres"
export pg="/usr/local/var/postgres"

# shorten misc things
alias serv2="python -m SimpleHTTPServer"
alias serv="python3 -m http.server"
# brew install ffmpeg && pip install youtube-dl
alias pirate='youtube-dl --extract-audio --audio-format mp3'
alias grip='grip -b'
alias https='http --default-scheme=https'
alias weather='curl "wttr.in/?m"'

if [[ $(uname) = Darwin ]]; then
  alias chrome="open -a /Applications/Google\ Chrome.app/"
else
  alias chrome="google-chrome"
fi

alias ipy='python -m IPython --no-confirm-exit'
alias ipy3='python3 -m IPython --no-confirm-exit'
alias py=python
alias py3=python3
alias jn='jupyter-notebook'
alias jl='jupyter-lab'
alias kub=kubectl
alias cls='printf "\033c"'
alias nr='npm run'
alias nt='npm test'
alias cr='cargo run'
alias vidu='vi $(git du)'

# compatibility stuff
if [[ $(uname) = Linux ]]; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

# typos
alias tit=git
alias gti=git
alias npmi='npm i'
alias gits='git s'
alias gitd='git d'


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

export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
