export ZSH="$ZDOTDIR/ohmyzsh"

# Theme
ZSH_THEME="rogemus"

# Plugins 
plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
  timer
)

# Oh My Zsh
DISABLE_UPDATE_PROMPT="true"
source $ZSH/oh-my-zsh.sh

source $ZDOTDIR/.aliasesrc
source $ZDOTDIR/.hooksrc
source $ZDOTDIR/.exportsrc
source $ZDOTDIR/.workrc
source $ZDOTDIR/.personalrc
