# ─── Plugins ───────────────────────────────────────────────────────
source $ZDOTDIR/modules/spinner.zsh
source $ZDOTDIR/modules/plugins.zsh

repos=(
  zsh-users/zsh-completions
  zsh-users/zsh-autosuggestions
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-history-substring-search
)

zsh-plugin-load $repos

# ─── Sourced configs ───────────────────────────────────────────────
source $ZDOTDIR/.keymaprc
source $ZDOTDIR/.aliasesrc
source $ZDOTDIR/.exportsrc
for f in .workrc .personalrc; do
  [[ -f $ZDOTDIR/$f ]] && source $ZDOTDIR/$f
done
source $ZDOTDIR/modules/node.zsh
source $ZDOTDIR/modules/completion.zsh
source $ZDOTDIR/modules/git.zsh
source $ZDOTDIR/.promptrc

# ─── Autosuggestions ───────────────────────────────────────────────
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#757575'
