#!/bin/bash

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
  nvm
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
  git-delta
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

