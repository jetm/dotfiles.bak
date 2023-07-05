# shellcheck disable=SC2148
#
# Global Key Bindings
#
# Use cat -v > /dev/null to know the keybinding
#

# Ctrl+right => forward word
bindkey "^[[1;5C" forward-word

# Ctrl+left => backward word
bindkey "^[[1;5D" backward-word

# same behavior from bash for vi-mode
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd ' ' edit-command-line

bindkey -M viins '^[[A' history-substring-search-up
bindkey -M viins '^[[B' history-substring-search-down

fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line -w
  else
    zle push-input -w
    zle clear-screen -w
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

fzf-aliases-widget() {
  LBUFFER="$LBUFFER$(FZF_DEFAULT_COMMAND=
  alias | sed 's/=/ --- /' | \
    awk -F '---' \
      '{
        print $1 "--" $2
      }' | \
    tr -d "'" | column -tl2 | \
    fzf --prompt=" Aliases > " \
        --ansi \
        --preview 'echo {3..} | bat --color=always --plain --language=sh' \
        --preview-window 'up:4:nohidden:wrap' | cut -d' ' -f 1)"
  zle reset-prompt
}

zle -N          fzf-aliases-widget
bindkey '^[a'   fzf-aliases-widget #<Alt-A>

fzf-functions-widget() {
  # shellcheck disable=SC2034
  LBUFFER="$LBUFFER$(FZF_DEFAULT_COMMAND=
    # ignore functions starting with "_ . +"
    # shellcheck disable=SC2296
    print -l ${(ok)functions[(I)[^_.+]*]} |
      fzf -q "$LBUFFER" --ansi --prompt=" Functions > "
  )"

  zle reset-prompt
}

zle -N          fzf-functions-widget
bindkey '^[f'   fzf-functions-widget #<Alt-F>

_fzf-ripgrep_() {
	RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
	INITIAL_QUERY="${*:-}"

	fzf_options=(
		--ansi
		--color "hl:-1:underline,hl+:-1:underline:reverse"
		--disabled --query "$INITIAL_QUERY"
		--bind "change:reload:sleep 0.1 && $RG_PREFIX {q} || true"
		--prompt '  ripgrep > '
		--delimiter :
		--header 'Ctrl-r ripgrep mode | Ctrl-f fzf mode '
		--preview 'bat --color=always {1} --highlight-line {2}'
		--preview-window 'nohidden,<60(nohidden,up,60%,border-bottom,+{2}+3/3,~3)'
	)

  command rm -f /tmp/rg-fzf-{r,f}
  FZF_DEFAULT_COMMAND="$RG_PREFIX $(printf %q "$INITIAL_QUERY")" fzf "${fzf_options[@]}" \
    --bind "ctrl-f:unbind(change,ctrl-f)+change-prompt(  fzf > )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)" \
    --bind "ctrl-r:unbind(ctrl-r)+change-prompt(  ripgrep > )+disable-search+reload($RG_PREFIX {q} || true)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
    --bind "start:unbind(ctrl-r)" \
    --bind "enter:become(${EDITOR:-vim} {1} +{2})"
}

fzf-ripgrep-widget() {
  _fzf-ripgrep_"$*" < "$TTY"
  zle redisplay
}

zle -N        fzf-ripgrep-widget
bindkey '^F'  fzf-ripgrep-widget   #<Ctrl-F>

# pressing CTRL-D will not close zsh
# if there's a text filled this one fixes it

exit_zsh() {
  exit
}

zle -N exit_zsh
bindkey '^D' exit_zsh

# ls if the buffer is empty if not transform text to lowercase
function magic-ls () {
    if [[ -z "$BUFFER" ]]; then
        BUFFER="ls"
        zle accept-line
    else
        zle down-case-word
    fi
}
zle -N magic-ls                                             # Ls if the BUFFER is empty if not transform to lowercase
bindkey '^[l' magic-ls                                      # Alt-l

# ls automatically after cd and git status if on a git repo
function cd () {
  auto_ls() {
    if command -v exa > /dev/null; then
      exa --all --icons --group-directories-first
    else
      ls -Fh --color=auto --group-directories-first
    fi
  }
    builtin cd "$@"
    if [[ -d .git ]]; then
      git status; echo ""
      auto_ls
    else
      auto_ls
    fi
}

function insert_sudo() {
    BUFFER="sudo $BUFFER"
    zle end-of-line;
}
zle      -N     insert_sudo                                 # Insert sudo at the beggining of the line
bindkey '^[s'   insert_sudo                                 # Alt-s

function execute_sudo!!() {
  [[ -z $BUFFER ]] &&
    zle .up-history
    zle accept-line
  LBUFFER=" sudo $LBUFFER"
}
zle     -N      execute_sudo!!                              # Execute the previous run command with sudo (similar to: insert-sudo + enter)
bindkey '^[S'   execute_sudo!!                              # Alt-Shift-S

function insert_cmd_sub {
    RBUFFER='$()'"$RBUFFER"
    ((CURSOR=CURSOR+2))
}
zle      -N   insert_cmd_sub                                 # Create command substitution `$()`
bindkey '^J'  insert_cmd_sub                                 # Ctrl-J

# execute the command and don't clear it
bindkey '^[^M'              accept-and-hold                 # Alt+Enter

# vim:set ft=zsh ts=2 sw=2 et:
