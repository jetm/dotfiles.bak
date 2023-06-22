# shellcheck disable=SC2148
FZF_DEFAULT_OPTS+=' --layout=reverse'
FZF_DEFAULT_OPTS+=' --info=inline'
FZF_DEFAULT_OPTS+=' --height=50%'
FZF_DEFAULT_OPTS+=' --multi'
FZF_DEFAULT_OPTS+=' --extended'
FZF_DEFAULT_OPTS+=' --preview-window=:down:80%:hidden'
FZF_DEFAULT_OPTS+=' --preview="[ -f {} ] && bat --style=grid,snip {} || [[ -d {}  ]] && tree -C {} | less"'
FZF_DEFAULT_OPTS+=' --prompt="∼ "'
FZF_DEFAULT_OPTS+=' --pointer="▶"'
FZF_DEFAULT_OPTS+=' --marker="✓"'
FZF_DEFAULT_OPTS+=' --bind "?:toggle-preview"'
FZF_DEFAULT_OPTS+=' --bind "ctrl-a:select-all"'
FZF_DEFAULT_OPTS+=' --bind "ctrl-d:deselect-all"'
FZF_DEFAULT_OPTS+=' --bind "ctrl-t:toggle-all"'
FZF_DEFAULT_OPTS+=' --bind "ctrl-e:become(nvim {} > /dev/tty)+abort"'
# shellcheck disable=SC2089
FZF_DEFAULT_OPTS+=' --bind "ctrl-o:execute-multi(nvim -p {} > /dev/tty)"'

# shellcheck disable=SC2090
export FZF_DEFAULT_OPTS

export FZF_COMPLETION_TRIGGER="@@"

export FZF_DEFAULT_COMMAND='fd --hidden --color never --strip-cwd-prefix'
export FZF_DEFAULT_COMMAND="${FZF_DEFAULT_COMMAND} --exclude .git --exclude .repo/"
export FZF_DEFAULT_COMMAND="${FZF_DEFAULT_COMMAND} --exclude build/"
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND} --type f"
export FZF_ALT_C_COMMAND="${FZF_DEFAULT_COMMAND} --type d"

# Show proper colors and not %F{yellow}
zstyle -d ':completion:*' format
zstyle ':completion:*:descriptions' format '[%d]'

#
# forgit
#
FORGIT_FZF_DEFAULT_OPTS="${FZF_DEFAULT_OPTS}"
FORGIT_FZF_DEFAULT_OPTS+=' --preview-window=:down:80%:nohidden'
export FORGIT_FZF_DEFAULT_OPTS

# FORGIT_DIFF_FZF_OPTS+=' --bind="ctrl-e:become(nvim {-1} > /dev/tty)"'
# export FORGIT_DIFF_FZF_OPTS
