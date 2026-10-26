#!/usr/bin/env zsh

# ─── Node version (lazy nvm) ───────────────────────────────────────
autoload -Uz add-zsh-hook

# nvm is loaded lazily: only on first `nvm` call or when a project asks for another Node version
load_nvm() {
  unset -f nvm load_nvm
  source /opt/homebrew/opt/nvm/nvm.sh
  source /opt/homebrew/opt/nvm/etc/bash_completion.d/nvm
}
nvm() { load_nvm && nvm "$@" }

function detect-node-version {
  setopt local_options extended_glob
  local file required current
  for file in .nvmrc .node-version; do [[ -f $file ]] && break; done
  [[ -f $file ]] || return

  required=${$(<$file)#v}
  required=${required//[[:space:]]/}

  # Current version, read from the node path (no subprocess)
  [[ $commands[node] == */versions/node/v(#b)([0-9.]##)/bin/node ]] && current=$match[1]
  [[ $current == $required ]] && return

  echo "Detected $fg_bold[white]$file$reset_color. Switching to $required..."
  (( $+functions[load_nvm] )) && load_nvm
  nvm use "$required"
}

add-zsh-hook chpwd detect-node-version

# Pick up .nvmrc when a terminal opens inside a project
detect-node-version
