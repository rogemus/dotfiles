#!/bin/bash 

source ./utils.sh 

install_homebrew() {
  info "Installing homebrew..."
  sudo --validate
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_homebrew
