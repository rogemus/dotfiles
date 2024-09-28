#!/bin/bash

source ./utils.sh 

install_xcode() {
  info "Installing xCode Command Line Tools..."
  xcode-select --install
  sudo xcodebuild -license accept
}

install_xcode
