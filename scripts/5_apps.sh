#!/bin/bash

source ./utils.sh 

apps=(
  alt-tab
  bruno
  google-chrome
  hiddenbar
  iterm2
  itsycal
  microsoft-edge
  microsoft-office
  microsoft-teams
  rectangle
  slack
  spotify
  telegram
  the-unarchiver
  transmission
  visual-studio-code
  vlc
  whatsapp
)

masApps=(
  "937984704"    # Amphetamine
  "1287239339"   # ColorSlurp
  "1284863847"   # Unsplash Wallpapers
  "570549457"    # Spotica Menu
  "1423210932"   # Flow - Focus & Pomodoro Timer
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
