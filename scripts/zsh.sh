#!/bin/zsh

install_plugins() {
  plugins=(
    zsh-history-substring-search
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-completions
  )

  info "Installing ZSH plugins..."
  brew install "${plugins[@]}"
}

