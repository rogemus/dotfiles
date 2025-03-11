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
  curl
  eza
  fdupes
  fnm
  fzf
  git
  git-delta
  go
  grep
  mas
  neovim
  python3
  ripgrep
  tree
  zoxide
  docker
  colima
  eddieantonio/eddieantonio/imgcat
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
