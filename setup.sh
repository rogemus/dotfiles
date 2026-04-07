#!/bin/bash

# Exit on error for critical commands
set -e

# Change to script's directory
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DOTFILES_DIR"

# Source utilities
source ./scripts/utils.sh

# Display welcome banner
banner "Dotfiles Setup - Starting Installation"

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to check if xcode tools are installed
xcode_installed() {
  xcode-select -p >/dev/null 2>&1
}

# Function to run a script from the scripts directory
run_script() {
  local script_name=$1
  local script_path="$DOTFILES_DIR/scripts/$script_name"
  
  if [ -f "$script_path" ]; then
    info "Running $script_name..."
    cd "$DOTFILES_DIR/scripts"
    bash "$script_path"
    cd "$DOTFILES_DIR"
    success "✓ $script_name completed"
    echo ""
  else
    echo "Error: $script_path not found"
    exit 1
  fi
}

# 1. Install Xcode Command Line Tools
banner "Step 1/7: Xcode Command Line Tools"
if xcode_installed; then
  info "Xcode Command Line Tools already installed, skipping..."
  echo ""
else
  run_script "1_xcode.sh"
fi

# 2. Install Homebrew
banner "Step 2/7: Homebrew"
if command_exists brew; then
  info "Homebrew already installed, skipping..."
  echo ""
else
  run_script "2_homebrew.sh"
  # Add Homebrew to PATH for current session
  if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# 3. Install Packages
banner "Step 3/7: Homebrew Packages"
run_script "3_packages.sh"

# 4. Install Fonts
banner "Step 4/7: Fonts"
run_script "4_fonts.sh"

# 5. Install Applications
banner "Step 5/7: Applications"
run_script "5_apps.sh"

# 6. Create Project Directories
banner "Step 6/7: Project Directories"
if [ -d "$HOME/Developer" ]; then
  info "Project directories already exist, skipping..."
  echo ""
else
  run_script "6_projectsdir.sh"
fi

# 7. Stow Dotfiles
banner "Step 7/7: Stowing Dotfiles"
run_script "7_stow.sh"

# Completion
banner "Dotfiles Setup Complete!"
success "All installation steps completed successfully!"
info "Please restart your terminal or run 'source ~/.zshrc' to apply changes."
echo ""
