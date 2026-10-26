# ─── Plugins ───────────────────────────────────────────────────────
source $ZDOTDIR/modules/spinner.zsh
source $ZDOTDIR/modules/plugins.zsh
source $ZDOTDIR/.pluginsrc

# ─── Sourced configs ───────────────────────────────────────────────
source $ZDOTDIR/.keymaprc
source $ZDOTDIR/.aliasesrc
source $ZDOTDIR/.exportsrc
for f in .workrc .personalrc; do
  [[ -f $ZDOTDIR/$f ]] && source $ZDOTDIR/$f
don
source $ZDOTDIR/modules/node.zsh
source $ZDOTDIR/modules/completion.zsh
source $ZDOTDIR/modules/git.zsh
source $ZDOTDIR/.promptrc
