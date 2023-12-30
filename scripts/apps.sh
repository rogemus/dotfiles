#!/bin/bash

apps=(
  alt-tab
  bruno
  iterm2
  slack
  microsoft-teams
  the-unarchiver
  transmission
  microsoft-office
  microsoft-edge
  itsycal
  spotify
  hiddenbar
  rectangle
  whatsapp
  telegram
  vlc
  zoom
  visual-studio-code
  google-chrome
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
  for app in $masApps; do
    brew install --cask $app
  done
}

install_macapps() {
  info "Installing App Store apps..."
  for app in $masApps; do
    mas install $app
  done
}

