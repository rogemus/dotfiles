#!/bin/bash

source ./utils.sh

taps=(
  homebrew/bundle
  homebrew/cask
  homebrew/core
  homebrew/services
)

packages=(
  bat
  eza
  nvm
  fzf
  git-delta
  go
  grep
  neovim
  ripgrep
  tree
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

configure_tabs
install_packages
