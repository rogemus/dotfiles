export ZSH="$ZDOTDIR/ohmyzsh"

# Theme
ZSH_THEME="rogemus"

# Plugins 
plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Oh My Zsh
DISABLE_UPDATE_PROMPT="true"
source $ZSH/oh-my-zsh.sh

source $ZDOTDIR/.aliasesrc
source $ZDOTDIR/.hooksrc
source $ZDOTDIR/.exportsrc
source $ZDOTDIR/.workrc
source $ZDOTDIR/.personalrc

# bun completions
[ -s "/Users/kacper.rogowski/.bun/_bun" ] && source "/Users/kacper.rogowski/.bun/_bun"
