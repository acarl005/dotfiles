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
alias less='less -XmiJF'
alias rn='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
# force tmux to use utf8 encoding so emojis and stuff render
alias tmux='tmux -u'
# https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '


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
alias r='r --no-save'
alias grip='grip -b'
alias https='http --default-scheme=https'
alias conk="conky -d -c ~/.conky/conkyrc_seamod"
alias root='cd $(git root)'

alias fm=foreman
alias ipy='ipython --no-confirm-exit'
alias py=python
alias py3=python3
alias 1p=op
alias jn='jupyter-notebook'
alias jl='jupyter-lab'
alias rstudio='open -a rstudio'
alias tb='tensorboard --logdir'
alias cls='printf "\033c"'

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

