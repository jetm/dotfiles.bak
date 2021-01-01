# ~/.bashrc: executed by bash(1) for non-login shells.

if [ -z "$PS1" ]; then
    # If not running interactively, don't do anything
    return
fi

if [ -d "$HOME"/local/share/man ]; then
    if test -n "$MANPATH"; then
        MANPATH=~/local/share/man:"${MANPATH}"
    else
        MANPATH=~/local/share/man
    fi
fi

unset CDPATH

export HOSTFILE=$HOME/.hosts # Put list of remote hosts in ~/.hosts
export PAGER="less"
export LESS="-I -j6 -M -F -X -R"

#
# Shell opts: see bash(1)
#
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
shopt -s cdable_vars    # if cd arg fail, assumes its a var defining a dir
shopt -s cdspell        # autocorrects cd misspellings
shopt -s cmdhist        # save multi-line commands in history as single line
shopt -s expand_aliases # expand aliases
shopt -s extglob        # enable extended pattern-matching features
shopt -s checkhash
shopt -s dirspell
shopt -s no_empty_cmd_completion
shopt -s dotglob      # include dotfiles in pathname expansion
shopt -s hostcomplete # attempt hostname expansion when @ is at the beginning of a word
#shopt -s nocaseglob         # pathname expansion will be treated as case-insensitive

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?} # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs} ]] &&
    type -P dircolors >/dev/null &&
    match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color}; then
    # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
    if type -P dircolors >/dev/null; then
        if [[ -f ~/.dir_colors ]]; then
            eval "$(dircolors -b ~/.dir_colors)"
        elif [[ -f /etc/DIR_COLORS ]]; then
            eval "$(dircolors -b /etc/DIR_COLORS)"
        fi
    fi

    if [[ ${EUID} == 0 ]]; then
        PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\]\n$ '
    else
        PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\n$ '
        #PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
    fi

    alias ls='ls -hF --color=always --group-directories-first'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
    if [[ ${EUID} == 0 ]]; then
        # show root@ when we don't have colors
        # PS1='\u@\h \W \$ '
        PS1='[\u@\h:\W] '
    else
        #PS1='\u@\h \w \$ '
        PS1='[\u@\h:\w] '
    fi
fi

# Try to keep environment pollution down, EPA loves us.
unset use_color safe_term match_lhs

if [ -n "$DISPLAY" ] && [ "$TERM" == "xterm" ] &&
    [ -e /usr/share/terminfo/x/xterm-256color ]; then
    export TERM=xterm-256color
fi

# Turn off annoying and useless flow control keys
stty -ixon

# debug bash script
debug() {
    local script="$1"
    shift
    bash -x "$(command -v "$script")" "$@"
}

# COV_PATH=/aruba/halon/infra/coverity/cov-analysis-linux64-8.0.0/bin
# if [ -d ${COV_PATH} ]; then
#     PATH=${COV_PATH}:"${PATH}"
# fi

# add user base to python path
# __PYTHON_PATH=$(python -c "import site, os; print(os.path.join(site.USER_BASE, 'lib', 'python3.4', 'site-packages'))"):$PYTHONPATH
# export PYTHONPATH="${__PYTHON_PATH}"

# set PATH so it includes user's private bin if it exists
if [ -d ~/bin ]; then
    PATH=~/bin:"${PATH}"
fi

# NODE_GLOBAL_PATH=$HOME/.npm-global/bin
# if [ -d "${NODE_GLOBAL_PATH}" ]; then
#     PATH="${NODE_GLOBAL_PATH}:${PATH}"
# fi

# RUST_GLOBAL_PATH=$HOME/.cargo/bin
# if [ -d "${RUST_GLOBAL_PATH}" ]; then
#     PATH="${RUST_GLOBAL_PATH}:${PATH}"
# fi
#
# LOCAL_PATH=$HOME/.local/bin
# if [ -d "${LOCAL_PATH}" ]; then
#     PATH="${LOCAL_PATH}:${PATH}"
# fi
#
# CABAL_PATH=$HOME/.cabal/bin
# if [ -d "${CABAL_PATH}" ]; then
#     PATH="${CABAL_PATH}:${PATH}"
# fi

#
# Other Alias
#
alias ll='ls -l'

# safety features
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias e=vim
export EDITOR='vim'
alias ..='cd ..'

# for t in $(cat /tmp/LEVEL2_8400); do TS_SOCKET=/ws/tiamarin/logs/ridley/l2/ridley.l2.socket TMPDIR=/ws/tiamarin/logs/ridley/l2 TS_SAVELIST=/ws/tiamarin/logs/ridley/l2/ridley.l2.ts-savelist ts -L 'LEVEL2_8400' ht -t $t -h 8400ANY -e jetm@hpe.com -y -waitForResults -i /aruba/pub/ridley-tiamarin-linux-yocto-4-4-93.swi; done
alias ts-ridley-l1='TS_SOCKET=/ws/tiamarin/logs/ridley/l1/ridley.l1.socket TMPDIR=/ws/tiamarin/logs/ridley/l1 ts'
alias ts-ridley-l2='TS_SOCKET=/ws/tiamarin/logs/ridley/l2/ridley.l2.socket TMPDIR=/ws/tiamarin/logs/ridley/l2 ts'
alias ts-topflite-l1='TS_SOCKET=/ws/tiamarin/logs/topflite/l1/topflite.l1.socket TMPDIR=/ws/tiamarin/logs/topflite/l1 TS_SAVELIST=/ws/tiamarin/logs/topflite/l1/topflite.l1.ts-savelist ts'
alias ts-topflite-l2='TS_SOCKET=/ws/tiamarin/logs/topflite/l2/topflite.l2.socket TMPDIR=/ws/tiamarin/logs/topflite/l2 TS_SAVELIST=/ws/tiamarin/logs/topflite/l2/topflite.l2.ts-savelist ts'
alias ts-until-brake='TS_SOCKET=/ws/tiamarin/logs/until-brake/until-brake.socket TMPDIR=/ws/tiamarin/logs/until-brake TS_SAVELIST=/ws/tiamarin/logs/until-brake.ts-savelist TS_MAILTO=jetm@hpe.com ts'

alias gerrit-code-nos="ssh -p 29418 javier.tia@code-nos.rose.rdlabs.hpecorp.net"

if (command -v keychain >/dev/null 2>&1); then
    # --clear option make sure an intruder cannot use your existing SSH-Agents keys
    [ -x /usr/bin/ruby ] && keychain --clear $HOME/.ssh/id_rsa

    [ -f $HOME/.keychain/$HOSTNAME-sh ] && source $HOME/.keychain/$HOSTNAME-sh
fi

# if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
# GIT_PROMPT_ONLY_IN_REPO=1
# source $HOME/.bash-git-prompt/gitprompt.sh
# GIT_PROMPT_END_USER=" \n${BoldBlue}${ResetColor}$ "
# GIT_PROMPT_END_ROOT=" \n${BoldBlue}${ResetColor}# "
# fi

#
# History Stuff
#

export HISTTIMEFORMAT="%H:%M > "
HISTIGNORE='&:[bf]g:ll:h:ls:clear:exit:\&:pwd:up:cd ..:'
HISTIGNORE=${HISTIGNORE}':cd ~-:cd -:cd:jobs:set -x:ls -l:top'
HISTIGNORE=${HISTIGNORE}':%1:%2:popd:top:halt:shutdown:reboot*'
export HISTIGNORE
shopt -s histreedit # reedit a history substitution line if it failed
shopt -s histverify # edit a recalled history line before executing

# HSTR configuration - add this to ~/.bashrc
alias hh=hstr              # hh to be alias for hstr
export HSTR_CONFIG=hicolor # get more colors
shopt -s histappend        # append new history items to .bash_history
export HISTCONTROL=ignoreboth:erasedups:ignorespace
export HISTFILESIZE=10000       # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE} # increase history size (default is 500)
# ensure synchronization between Bash memory and history file
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}"

# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi

# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
# if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi

#
# Ctrl-r
#
if (command -v sk >/dev/null 2>&1); then
    if (command -v fd >/dev/null 2>&1); then
        if [ -f /ws/tiamarin/shell-goodies/skim/shell/key-bindings.bash ]; then
            source /ws/tiamarin/shell-goodies/skim/shell/key-bindings.bash
        fi
    fi
fi

#
# VM settings
#
# HPE_PROXY=http://web-proxy.rose.hpecorp.net:8088

# All variables in lowercase
# export http_proxy="${HPE_PROXY}"
# export https_proxy="${HPE_PROXY}"
# export ftp_proxy="${HPE_PROXY}"

# All variables in UPPERCASE
# export HTTP_PROXY="${HPE_PROXY}"
# export HTTPS_PROXY="${HPE_PROXY}"
# export FTP_PROXY="${HPE_PROXY}"
# export no_proxy='localhost,127.0.0.1,localhost6,::1,.localdomain,hpecorp.net'

# aliases for git
alias g='git'
alias gnp='git --no-pager'
complete -o default -o nospace -F _git g
alias giA='git add --patch'

if [ -f "$HOME"/.git-completion.bash ]; then
    source "/users/tiamarin/.git-completion.bash"
    complete -o default -o nospace -F _git g
fi

alias fix-code-format='git --no-pager diff --name-only HEAD~ HEAD | grep "\.[ch]$" | xargs clang-format -i -style=file'

if [ -f /usr/share/autojump/autojump.sh ]; then
    source /usr/share/autojump/autojump.sh
fi

if [[ $(lsb_release -i) = *Ubuntu* ]]; then
    source /aruba/halon/infra/halon.profile
    remove_PATH_duplicates
    unalias bb
fi

# ln -sf "$SSH_AUTH_SOCK" "$HOME/.ssh/ssh-auth-sock.$HOSTNAME"

source /users/tiamarin/.config/broot/launcher/bash/br

# [ -f ~/.fzf.bash ] && source ~/.fzf.bash
