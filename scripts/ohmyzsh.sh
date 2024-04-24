#!/bin/zsh


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
  curl -L -o ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/rogemus.zsh-theme https://gist.githubusercontent.com/rogemus/b565bf7ed054f1146f456bf43e780de0/raw/61a879f4f081860cc58b8dd197470e328684cbb0/rogemus2.zsh-theme
}

"$@"
