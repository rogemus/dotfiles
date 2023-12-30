#!/bin/bash

cleanup_dotfiles() {
  local files=(
    ".zprofile"
    ".zshrc"
    ".zshenv"
  )

  local folders=(
    ".config/nvim"
    ".config/zsh"
  )

  echo "Removing existing config files"
  for f in $files; do
    rm -f "$HOME/$f" || true
  done

  for d in $folders; do
    rm -rf "$HOME/$d" || true
    mkdir -p "$HOME/$d"
  done
}

stow_dotfiles() {
  local dotfiles="nvim zsh"
  echo "Stowing: $dotfiles"
  stow --verbose 1 --ignore='.*\.DS_Store' --target $HOME $dotfiles
}

