#!/bin/bash

npmPackages=(
  bash-language-server
  dot-language-server
  pyright
  svelte-language-server
  typescript
  typescript-language-server
  vim-language-server
  vscode-langservers-extracted
)

brewPackages=(
  lua-language-server
)

install_lsp_servers() {
  info "Installing LSP npm packages..."
  echo "Installing: ${npmPackages[@]}"
  npm install -g ${npmPackages[@]}

  info "Installing LSP Brew packages..."
  echo "Installing: ${brewPackages[@]}"
  brew install "${brewPackages[@]}"
}

