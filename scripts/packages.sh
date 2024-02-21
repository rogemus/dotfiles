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
  curlie
  eza
  fdupes
  fnm
  fzf
  git
  git-delta
  grep
  mas
  neovim
  pyenv
  python3
  ripgrep
  rust
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

