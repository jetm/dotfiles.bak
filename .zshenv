# Terminals with any of the following set, support 256 colors (and are local)
local256="$COLORTERM$XTERM_VERSION$ROXTERM_ID$KONSOLE_DBUS_SESSION"

if [ -n "$local256" ] || [ -n "$SEND_256_COLORS_TO_REMOTE" ]; then

  case "$TERM" in
    'xterm') TERM=xterm-256color;;
    'screen') TERM=screen-256color;;
    'Eterm') TERM=Eterm-256color;;
  esac
  export TERM

  if [ -n "$TERMCAP" ] && [ "$TERM" = "screen-256color" ]; then
    TERMCAP=$(echo "$TERMCAP" | sed -e 's/Co#8/Co#256/g')
    export TERMCAP
  fi
fi

unset local256

unset CDPATH

export HOSTFILE=$HOME/.hosts    # Put list of remote hosts in ~/.hosts
export PAGER="less"
export LESS="-I -j6 -M -F -X -R"

# Setting for Ubuntu/Debian packaging
export DEBFULLNAME="Javier Tia"
export DEBEMAIL="javier.tia@gmail.com"

# Set vim Global editor
[ -x /usr/bin/vim ] && export EDITOR=vim

# Go settings
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ] ; then
  PATH="${PATH}":~/bin
fi

if [ -d /tools ] ; then
  PATH="${PATH}":/tools
fi

if [ -d /usr/local/bin ] ; then
  PATH="${PATH}":/usr/local/bin
fi

if [ -x /usr/bin/ruby -a -x /usr/bin/gem ] ; then
  PATH=$(ruby -rubygems -e "puts Gem.user_dir")/bin:"${PATH}"
fi

if [ -d ${HOME}/.rvm/bin ] ; then
  PATH=${PATH}:${HOME}/.rvm/bin # Add RVM to PATH for scripting
fi

