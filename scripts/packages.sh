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
  zshe
  mas
  curl
  wget
  rust
  python3
)

configure_tabs() {
  echo "Configuring Brew tabs..."
  
  for tap in $taps; do
    brew tap $tap
  done
}

install_packages() {
  echo "Installing Brew packages..."
  brew install "${packages[@]}"
}

