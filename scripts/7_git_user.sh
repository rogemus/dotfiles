#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/utils.sh"

# Stowed to ~/.gitconfig-user, included from git/.gitconfig
TARGET="$SCRIPT_DIR/../git/.gitconfig-user"

create_git_user() {
  if [ -f "$TARGET" ]; then
    info "git/.gitconfig-user already exists, skipping..."
    return
  fi

  local name email
  read -r -p "Git user name: " name
  read -r -p "Git user email: " email

  if [ -z "$name" ] || [ -z "$email" ]; then
    echo "Error: name and email are required"
    exit 1
  fi

  cat > "$TARGET" <<EOF
[user]
  name = $name
  email = $email
EOF

  success "Created git/.gitconfig-user"
}

create_git_user
