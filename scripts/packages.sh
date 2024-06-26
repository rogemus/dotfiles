#!/bin/zsh

taps=(
  homebrew/bundle
  homebrew/cask
  homebrew/core
  homebrew/services
)

packages=(
  bat
  btop
  curl
  eza
  fdupes
  fnm
  fzf
  git
  git-delta
  go
  grep
  hugo
  mas
  neovim
  postgresql@15
  pyenv
  python3
  ripgrep
  rust
  thefuck
  tldr
  tree
  wget
  zoxide
  zsh
)

configure_tabs() {
  info "Configuring Brew tabs..."
  
  for tap in $taps; do
    brew tap $tap
  done
}

install_packages() {
  info "Installing Brew packages..."
  brew install "${packages[@]}"
}

