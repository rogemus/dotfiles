#!/bin/bash

source ./utils.sh 

fonts=(
  font-fira-code
  font-fira-code-nerd-font
)

install_fonts() {
  info "Installing fonts..."
  brew tap homebrew/cask-fonts

  for font in $fonts; do
    brew install --cask $font
  done
}

install_fonts
