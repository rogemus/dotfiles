# ─── Plugins ───────────────────────────────────────────────────────
source $ZDOTDIR/modules/spinner.zsh
source $ZDOTDIR/modules/plugins.zsh
source $ZDOTDIR/.pluginsrc

# ─── Sourced configs ───────────────────────────────────────────────
source $ZDOTDIR/.keymaprc
source $ZDOTDIR/.aliasesrc
source $ZDOTDIR/.exportsrc
source $ZDOTDIR/modules/paths.zsh
source $ZDOTDIR/.pathsrc
for f in .workrc .personalrc; do
  [[ -f $ZDOTDIR/$f ]] && source $ZDOTDIR/$f
done

# Dedupe PATH after the optional rc files, which append to it. Assigning the array applies
# `typeset -U path` (modules/paths.zsh), the `export PATH=` lines alone do not
path=($path)

source $ZDOTDIR/modules/node.zsh
source $ZDOTDIR/modules/completion.zsh
source $ZDOTDIR/modules/git.zsh
source $ZDOTDIR/.promptrc
