set fish_greeting
fish_vi_key_bindings

bind -M insert ctrl-r history-pager
bind U redo
bind -M insert ctrl-delete kill-word
bind -M insert ctrl-backspace backward-kill-word
bind -M insert alt-backspace backward-kill-word
bind -M insert ctrl-right forward-word
bind -M insert ctrl-left backward-word
bind -M insert alt-right nextd-or-forward-word
bind -M insert alt-left prevd-or-backward-word
bind -M insert shift-right forward-bigword
bind -M insert shift-left backward-bigword

if test -x /opt/homebrew/bin/brew
  eval (/opt/homebrew/bin/brew shellenv)
end

if status is-interactive
  alias ff='fastfetch --logo-color-1 94 --logo-color-2 94 --color-keys 94 --color-title 94'
  alias of=onefetch
  if type -q starship
    starship init fish | source
  end
  if test -d .git && type -q onefetch
    of
  else if type -q fastfetch
    ff
  else if type -q pfetch
    # I disabled "packages"
    set PF_INFO "ascii title os host kernel uptime memory shell editor wm de palette"
    pfetch
  end
end

set EDITOR vi
if type -q nvim
  set EDITOR nvim
else if type -q vim
  set EDITOR vim
end

set VISUAL $EDITOR
alias v=$EDITOR
alias vi=$EDITOR
alias vim=$EDITOR

if type -q ls-go
  alias ll='ls-go -alLkn'
else
  if test (uname -s) = Linux
    alias ll='command ls -FlAhp --color=auto'
  else
    alias ll='command ls -FGlAhp'
  end
end

function cd
  builtin cd $argv && ll
end

function mkcd
  mkdir -p "$argv[1]" && cd "$argv[1]"
end

function root
  builtin cd (git root)
  if test -d .git && command -v onefetch >/dev/null
    onefetch
  end
  ll
end

function ya
  set tmp (mktemp -t "yazi-cwd.XXXXXX")
  yazi $argv --cwd-file="$tmp"
  if set cwd (cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
    cd "$cwd"
  end
  rm -f -- "$tmp"
end

if test -d ~/.local/bin
  fish_add_path ~/.local/bin
end
if test -d ~/go/bin
  fish_add_path ~/go/bin
end
if test -d ~/.cargo/bin
  fish_add_path ~/.cargo/bin
end
if test -d ~/.volta
  set -gx VOLTA_HOME "$HOME/.volta"
  fish_add_path "$VOLTA_HOME/bin"
end

alias py3=python3
alias ipy3='python3 -m IPython --no-confirm-exit'

alias gits="git s"
alias gitd="git d"
alias grep='grep --exclude-dir=node_modules --color=auto'
alias cp='cp -iv'
alias mv='mv -iv'
alias less='less -miJ'
alias desk='cd ~/Desktop'
alias vidu='vi (git du)'

if test -f "$HOMEBREW_PREFIX/share/autojump/autojump.fish"
  source "$HOMEBREW_PREFIX/share/autojump/autojump.fish"
else if test -f /usr/share/autojump/autojump.fish
  source /usr/share/autojump/autojump.fish
end
