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
    "~/.config/yazi"
    "~/.config/lazygit"
    "~/.config/iTerm"
    # "~/Library/Application Support/iTerm2/DynamicProfiles",
    "~/Library/Application Support/Rectangle"
  )

  # info "Removing existing config files"
  rm -f ${files[@]}

  # info "Removing existing config directories"
  rm -rf ${folders[@]}
}

stow_dotfiles() {
  local dotfiles="nvim zsh git iTerm rectangle lazygit yazi iTerm"
  local dirPath=$(pwd)
  # info "Stowing: $dotfiles"
  stow --verbose 1 --target ~/ $dotfiles
}

unstow_dotfiles() {
  local dotfiles="nvim zsh git iTerm rectangle lazygit yazi iTerm"
  stow --delete --verbose 1 --target ~/ $dotfiles
}

cleanup_dotfiles
stow_dotfiles
