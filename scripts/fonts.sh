#!/bin/bash

fonts=(
  font-fira-code
  font-fira-code-nerd-font
)

install_fonts() {
  echo "Installing fonts..."
  brew tap homebrew/cask-fonts

  for font in $fonts; do
    brew install --cask $font
  done
}
