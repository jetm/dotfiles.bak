# Remove all aliases
unalias -m '*'

#
# Aliases
#

# Disable correction
alias -g type='type -a'

alias -g rm='rm -i'
alias -g mv='mv -i'
alias -g cp='cp -i'
alias -g ln='ln -i'

alias -g mkdir='mkdir -p'

# Reload the Zsh configurations
alias reload="exec $SHELL -i -l"

# exa
alias l='exa -l'
alias la='exa -a'
alias lt='exa --tree'

# rg -o 'g\w+=' ~/.zsh/zsh-abbr-alias.conf | tr -d '=' | sort | xargs -n1 -I{} echo "'{}'"
# export YSU_IGNORED_GLOBAL_ALIASES=(
# '..' '...' 'up' 'cd-'
# 'l' 'la' 'lt' 'ls'
# 'e' 'vim' 'vimdiff'
# 'pain' 'pains' 'paorph' 'parem' 'paremALL' 'pasp' 'paud'
# 'fdi' 'list-path' 'reload'
# 'zi' 'bb' 'g'
# 'ga' 'gap' 'gb' 'gbd' 'gbm' 'gbv' 'gc' 'gc-' 'gca' 'gcb' 'gcf' 'gch' 'gcl'
# 'gco' 'gcp' 'gcs' 'gd' 'gdc' 'gfcf' 'gfe' 'gfi' 'gg' 'gl' 'gla' 'gll' 'gls'
# 'gp' 'gpp' 'gpr' 'gpu' 'gr' 'gra' 'grc' 'gre' 'grf' 'grh' 'gri' 'grs' 'gs'
# 'gsd' 'gsp' 'gss' 'gt' 'gu' 'guh'
# )

# Abbreviation
# abbrev-alias --init

# General
alias e="nvim"
alias vim="nvim"
alias vimdiff="nvim -d"
alias up="cd ../"
alias cd-="cd -"
alias fdi="fd -t f -o $USER -l -d 1 . /aruba/pub"
alias ls="exa"
alias df="duf"
alias bb="bitbake"

#
# Git
#
alias g="git"

# Branch (b)
alias gb='git branch'
alias gbd='git branch -D'
alias gbv='git branch -vv'
alias gbm='git branch -M'

# Commit (c)
alias gc='git commit'
alias gca='git commit --all'
alias gcf='git commit --amend'
alias gch='git cherry-pick -x'
alias gcs='git show'

# Checkout (c)
alias gco='git checkout'
alias gfcf='forgit::checkout::file'
alias gcp='git checkout --patch'
alias gcb='git checkout -b'
alias gc-='git checkout -'
alias gre='git restore'
alias grs='git restore --staged'

# Restore (r)
alias grf='git reset-file'
alias grh='forgit::reset::head'

# Grep (g)
alias gg='git grep'

# Index (a)
alias ga='forgit::add'
alias gap='git add --patch'

# Diff (d)
alias gd='forgit::diff'
alias gdc='forgit::diff --cached'

# Log (l)
alias gl='git lg'
alias gla='git last'
alias gll='git lol'

# Push (p)
alias gp='git push'
alias gpp='git push --force-with-lease'
alias gpr='git publish -t'

# Rebase (r)
alias gr='git rebase'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias gri='git rebase --interactive'

# Stash (s)
alias gs='git stash'
alias gsd='git stash drop'
alias gsp='git stash pop'
alias gss='git stash show'

# Undo (u)
alias gu='git undo'
alias guh='git undo -h'

# rest
alias gfi='git fixup-prev-ci'
alias gcl='git clone'
alias gfe='git fetch'
alias gls='git ls-files'
alias gpu='git pull'
alias gt='git status'

# git fuzzy
alias gzt='git fuzzy status'
alias gzb='git fuzzy branch'

#
# Arch Linux Stuff
#
if [ -f /etc/arch-release ] || [ -f /etc/manjaro-release ]; then
  #
  # Pacman aliases
  #

  # Recursively removing orphans (be careful)
  alias paorph='sudo pacman -Rs $(pacman -Qtdq)'

  # Remove ALL packages from cache
  alias paremALL='sudo pacman -Scc'

  # Remove the specified package(s), its configuration(s) and unneeded
  # dependencies
  alias parem='sudo pacman -Rns'

  if (command -v yay > /dev/null 2>&1); then
    # Upgrade all packages
    alias paud='yay -Syu --devel'

    # Install specific package(s) from local and AUR
    alias pain='yay -S'

    # Install specific package from source package
    alias pains='yay -U'

    # Search for package(s) for local and AUR
    alias pasp='yay'
  fi
fi
