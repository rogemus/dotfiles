#!/bin/bash
install_ohmyzsh() {
  info "Installing Oh-My-ZSH..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

install_plugins() {
  info "Installing Oh-My-ZSH Plugins..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

install_theme() {
  info "Installing Oh-My-ZSH Theme..."
  curl -L -o ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/rogemus.zsh-theme https://gist.githubusercontent.com/rogemus/a0db270ce9da824d53532f00754c5170/raw/962c6731c678e06c074a21b66976acd2fc8fbec3/rogemus.zsh-theme
}

