#!/bin/bash

. scripts/apps.sh
. scripts/fonts.sh
. scripts/homebrew.sh
. scripts/packages.sh
. scripts/stow.sh
. scripts/xcode.sh
. scripts/zsh.sh

main() {
	echo "Installing ..."

	echo "################################################################################"
	echo "Xcode"
	echo "################################################################################"
  install_xcode

	echo "################################################################################"
	echo "Homebrew"
	echo "################################################################################"
	install_homebrew
  configure_tabs
  install_packages
  install_fonts
  
	echo "################################################################################"
	echo "Apps"
	echo "################################################################################"
  install_apps
  install_macapps

	echo "################################################################################"
	echo "Stow"
	echo "################################################################################"
  cleanup_dotfiles
  stow_dotfiles

	echo "################################################################################"
	echo "Oh-My-ZSH"
	echo "################################################################################"
  install_ohmyzsh
  install_plugins
  install_theme

  echo "🎉 Configuration completed 🎉"
}

main

