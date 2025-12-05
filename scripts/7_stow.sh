#!/bin/bash

cleanup_dotfiles() {
  local files=(
    "~/.zprofile"
    "~/.zshrc"
    "~/.zshenv"
    "~/.gitconfig"
    "~/.hushlogin"
  )

  local folders=(
    "~/.config/nvim"
    "~/.config/zsh"
    "~/.config/git"
    "~/.config/lazygit"
    "~/.config/tmux"
    "~/.config/alacritty"
    "~/.config/ghostty"
    "~/.config/lazydocker"
  )

  # info "Removing existing config files"
  rm -f ${files[@]}

  # info "Removing existing config directories"
  rm -rf ${folders[@]}
}

stow_dotfiles() {
  local dotfiles="nvim zsh git lazygit tmux ghostty lazydocker"
  local dirPath=$(pwd)
  # info "Stowing: $dotfiles"
  stow --verbose 1 --target ~/ $dotfiles
}

unstow_dotfiles() {
  local dotfiles="nvim zsh git lazygit tmux ghostty lazydocker"
  stow --delete --verbose 1 --target ~/ $dotfiles
}

cleanup_dotfiles
# stow_dotfiles
# unstow_dotfiles 
