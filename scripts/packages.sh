#!/bin/zsh

taps=(
  homebrew/bundle
  homebrew/cask
  homebrew/core
  homebrew/services
)

packages=(
  git
  grep
  tree
  ripgrep
  neovim
  pyenv
  wget
  zsh
  mas
  curl
  wget
  rust
  python3
  bun
  fnm
  fdupes
  btop
  eza
  curlie
  bat
  fzf
  git-delta
  zoxide
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

