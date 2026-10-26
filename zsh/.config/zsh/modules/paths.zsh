#!/usr/bin/env zsh

# ─── PATH ──────────────────────────────────────────────────────────
# Keep the first occurrence of every entry, so repeated sourcing and nested shells add no duplicates
typeset -U path

# Put the existing directories in front of PATH, in the given order (first entry wins).
# Missing directories are skipped. Usage: zsh-path-add $paths
function zsh-path-add {
  local dir
  local -a dirs
  for dir in $@; do
    [[ -d $dir ]] && dirs+=($dir)
  done
  path=($dirs $path)
}
