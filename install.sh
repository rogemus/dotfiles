#!/bin/bash

. scripts/utils.sh
. scripts/apps.sh
. scripts/fonts.sh
. scripts/homebrew.sh
. scripts/packages.sh
. scripts/stow.sh
. scripts/xcode.sh
. scripts/zsh.sh

main() {
	info "Installing ..."

  banner "XCode"
  install_xcode
  success "✅ Finished installing Homebrew packages 🚀"
  printf "\n"

	banner "Homebrew"
  install_homebrew
  configure_tabs
  install_packages
  install_fonts
  success "✅ Finished installing Homebrew and all packages 🚀"
  printf "\n"

  banner "Apps"
  install_apps
  install_macapps
  success "✅ Finished installing all apps 🚀"
  printf "\n"

  banner "Stow and dotfiles"
  cleanup_dotfiles
  stow_dotfiles
  success "✅ Finished installing all dotfiles 🚀"
  printf "\n"

  banner "Oh-My-ZSH"
  install_ohmyzsh
  install_plugins
  install_theme
  success "✅ Finished installing Oh-My-ZSH 🚀"
  printf "\n"

  success "🎉 Configuration completed!!! 🎉"
}

main

