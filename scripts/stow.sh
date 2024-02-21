#!/bin/zsh

cleanup_dotfiles() {
  local files=(
    ".zprofile"
    ".zshrc"
    ".zshenv"
    ".gitconfig"
    ".hushlogin"
  )

  local folders=(
    ".config/nvim"
    ".config/zsh"
    ".config/git"
    ".config/btop"
    ".oh-my-zsh"
    "Library/Application\ Support/iTerm2/DynamicProfiles",
    "Library/Application\ Support/Rectangle"
  )

  info "Removing existing config files"
  for f in $files; do
    rm -f "$HOME/$f" || true
  done

  info "Removing existing config directories"
  for d in $folders; do
    rm -rf "$HOME/$d" || true
    mkdir -p "$HOME/$d"
  done
}

stow_dotfiles() {
  local dotfiles="nvim zsh btop git iTerm rectangle"
  info "Stowing: $dotfiles"
  stow --verbose 1 --ignore='.*\.DS_Store' --target $HOME $dotfiles
}

