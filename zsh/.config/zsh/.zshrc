ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}

if [[ ! -d $ZPLUGINDIR/zsh_unplugged ]]; then
  git clone --quiet https://github.com/mattmc3/zsh_unplugged $ZPLUGINDIR/zsh_unplugged
fi

source $ZPLUGINDIR/zsh_unplugged/zsh_unplugged.zsh

repos=(
  zsh-users/zsh-completions
  romkatv/zsh-defer
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-history-substring-search
)

plugin-load $repos

# Completion (after plugin-load so zsh-completions is on fpath)
autoload -Uz compinit && compinit -C
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu select

source $ZDOTDIR/.keymap
source $ZDOTDIR/.aliasesrc
source $ZDOTDIR/.hooksrc
source $ZDOTDIR/.exportsrc
for f in .workrc .personalrc; do
  [[ -f $ZDOTDIR/$f ]] && source $ZDOTDIR/$f
done
source $ZDOTDIR/.appsrc

# Pick up .nvmrc when a terminal opens inside a project
detect-node-version

# Prompt
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats '%F{blue}(%f%F{red}%b%f%F{blue})%f %F{yellow}%u%f%F{cyan}%c%f'
zstyle ':vcs_info:git:*' actionformats '%F{blue}(%f%F{red}%b%f%F{blue})%f%F{blue}[%f%F{cyan}%a%f%F{blue}]%f %F{yellow}%u%f%F{cyan}%c%f'
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

setopt prompt_subst

+vi-git-untracked(){
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
    git status --porcelain | grep -q '^?? ' 2> /dev/null ; then
    hook_com[staged]+="!"
  fi
}

PS1='%B%F{green}%2~%f ${vcs_info_msg_0_}
>%b '
RPROMPT=""
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#757575'
