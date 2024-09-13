eval (/opt/homebrew/bin/brew shellenv)

if status is-interactive
  starship init fish | source
  fastfetch
end

set EDITOR nvim
alias v=nvim
alias vi=nvim
alias vim=nvim
alias ll='ls-go -alLkn'

function cd
  builtin cd "$argv" && ll
end

function mkcd
  mkdir -p "$argv[1]" && cd "$argv[1]"
end

function root
  builtin cd (git root)
  if [ -d .git ] && command -v onefetch >/dev/null
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

[ -d "$HOME/bin" ]; and fish_add_path "$HOME/bin"
[ -d "$HOME/.local/bin" ]; and fish_add_path "$HOME/.local/bin"
[ -d "$HOME/go/bin" ]; and fish_add_path "$HOME/go/bin"
[ -d "$HOME/.cargo" ]; and source "$HOME/.cargo/env.fish"

alias py3=python3
alias ipy3='python3 -m IPython --no-confirm-exit'

alias gits="git s"
alias gitd="git d"
alias f='fortune | cowsay -f tux'
alias pony='fortune | ponysay -b round'
alias grep='grep --exclude-dir=node_modules --color=auto'
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias chx='chmod +x'
alias less='less -miJ'
alias rn='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
alias desk='cd ~/Desktop'
alias cr='cargo run'
alias vidu='vi (git du)'

[ -f "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.fish.inc" ]; and source "$HOMEBREW_PREFIX/share/google-cloud-sdk/path.fish.inc"
[ -f "$HOMEBREW_PREFIX/share/autojump/autojump.fish" ]; and source "$HOMEBREW_PREFIX/share/autojump/autojump.fish"
