# some more aliases

# shell stuff
alias grep='grep --exclude-dir=node_modules'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
if [[ `uname -s` = Linux ]]; then
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
csv_less() {
  sed -e "s/^,/␀,/" -e "s/,,/,␀,/g" -e "s/,$/,␀/" $1 | sed -e "s/,,/,␀,/g" | column -s, -t | less -#2 -N -S
}
alias cwd='pwd | tr -d "\n" | pbcopy'


#full recursive directory listing
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

# write the zsh commands for going up directories by typing a number of dots
DOTS=..
ARG=..
for i in `seq 1 11`; do
  alias $DOTS="cd $ARG"
  DOTS="${DOTS}."
  ARG="${ARG}/.."
done

alias e=$EDITOR
if command -v nvim >/dev/null; then
  alias vi=nvim
  alias vim=nvim
fi


if command -v batcat >/dev/null; then
  alias bat=batcat
fi

# jump to commonly used directories
alias desk="pushd $HOME/Desktop"
export desk="$HOME/Desktop"
alias proj="pushd $HOME/Documents/projects"
export proj="$HOME/Documents/projects"
alias stem="pushd $HOME/Documents/stem"
export stem="$HOME/Documents/stem"
alias down="pushd $HOME/Downloads"
export down="$HOME/Downloads"
alias docs="pushd $HOME/Documents"
export docs="$HOME/Documents"
alias pg="/usr/local/var/postgres"
export pg="/usr/local/var/postgres"

# shorten misc things
alias al='e ~/.bash_aliases && . ~/.bash_aliases'
alias rc='e ~/.bashrc'
alias serv="python -m SimpleHTTPServer"
alias serv3="python -m http.server"
if [[ $(uname) = Darwin ]]; then
  alias chrome="open -a /Applications/Google\ Chrome.app/"
else
  alias chrome="google-chrome"
fi
alias u='echo -n `uuid` | pbcopy'
alias pirate='youtube-dl --extract-audio --audio-format mp3'
alias probe='ffprobe -of json -show_streams -show_format'
alias R='R --no-save'
alias r='r --no-save'
alias grip='grip -b'
alias https='http --default-scheme=https'
alias conk="conky -d -c ~/.conky/conkyrc_seamod"
alias weather='curl wttr.in/?m'

root() {
  builtin cd $(git root)
  if [ -d .git ] && command -v onefetch >/dev/null; then
    onefetch
  fi
  ll
}

alias ipy='python -m IPython --no-confirm-exit'
alias py=python
alias py3=python3
alias jn='jupyter-notebook'
alias jl='jupyter-lab'
alias rstudio='open -a rstudio'
alias tb='tensorboard --logdir'
alias kub=kubectl
alias cls='printf "\033c"'

# compatibility stuff
if [[ $(uname) = Linux ]]; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

#typos
alias tit=git
alias gti=git
alias npmi='npm i'
alias gits='git s'


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

