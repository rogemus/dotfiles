#!/bin/bash

source ./utils.sh 

apps=(
  google-chrome
  microsoft-edge
  microsoft-office
  microsoft-teams
  rectangle
  slack
  visual-studio-code
  whatsapp
  ghostty
  firefox
  cloude-code
  copilot-cli
  # transmission
  # alt-tab
  # hiddenbar
)

masApps=(
  "1284863847"   # Unsplash Wallpapers
)

install_apps() {
  info "Installing Brew apps..."
  brew install --cask "${packages[@]}"
}

install_macapps() {
  info "Installing App Store apps..."
  for app in $masApps; do
    mas install $app
  done
}

install_apps
install_macapps
