#!/bin/bash

install_xcode() {
  info "Installing xCode Command Line Tools..."
  xcode-select --install
  sudo xcodebuild -license accept
}
