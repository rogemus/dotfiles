#!/bin/bash

source ./utils.sh

taps=(
  homebrew/bundle
  homebrew/cask
  homebrew/core
  homebrew/services
)

packages=(
  awscli
  bat
  cloc
  docker
  docker-compose
  docker-credential-helper
  duckdb
  eza
  fd
  fx
  fzf
  gh
  git-delta
  go
  gotestsum
  grep
  helm
  hey
  hugo
  just
  kubeconform
  kubernetes-cli
  lazydocker
  lazygit
  lua
  luarocks
  neovim
  nvm
  opencode
  ripgrep
  stow
  terraform
  tmux
  tree
  wget
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
