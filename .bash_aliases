# some more aliases

# shell stuff
alias grep='grep --exclude-dir=node_modules'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias ls='ls -Gp'
alias less='less -SXcmiJF'
alias rn='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
# https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '

# write the zsh commands for going up directories by typing a number of dots
DOTS=..
ARG=..
for i in `seq 1 11`; do
  alias $DOTS="cd $ARG"
  DOTS="${DOTS}."
  ARG="${ARG}/.."
done

alias e=$EDITOR
alias vi=vim

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
if [[ $(uname) = Darwin ]]; then
  alias chrome="open -a /Applications/Google\ Chrome.app/"
else
  alias chrome="google-chrome"
fi
alias u='echo -n `uuid` | pbcopy'
alias pirate='youtube-dl --extract-audio --audio-format mp3'
alias probe='ffprobe -of json -show_streams -show_format'
alias r='r --no-save'
alias grip='grip -b'
alias https='http --default-scheme=https'
alias conk="conky -d -c ~/.conky/conkyrc_seamod"

alias fm=foreman
alias ipy=ipython
alias py=python
alias py3=python3
alias ns="npm start"
alias root='cd $(git root)'
alias rstudio='open -a rstudio'

# work stuff
alias bastion='ssh -A ec2-user@54.208.41.126'

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

alias w205='docker run -it --rm -v /Users/andy/Documents/MIDS/w205/docker-volume:/w205 midsw205/base:latest bash'
