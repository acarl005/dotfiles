. ~/common-config.sh

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

if command -v starship >/dev/null && [[ $(tty) != '/dev/tty1' ]]; then
  eval "$(starship init bash)"
fi

if [ -f "$HOMEBREW_PREFIX/share/autojump/autojump.bash" ]; then
  . "$HOMEBREW_PREFIX/share/autojump/autojump.bash"
elif [ -f /usr/share/autojump/autojump.bash ]; then
  . /usr/share/autojump/autojump.bash
fi
