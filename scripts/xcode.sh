#!/bin/bash

install_xcode() {
  echo "Installing xCode Command Line Tools..."
  xcode-select --install
  sudo xcodebuild -license accept
}
