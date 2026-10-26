#!/usr/bin/env zsh

# ─── Git prompt segment (async) ────────────────────────────────────
# Fills ${_prompt_git} for the prompt, see .promptrc

# Runs in a background subshell: one git call, prints a ready-made prompt segment
function _prompt_git_segment {
  local line branch oid x y
  local -i staged=0 unstaged=0 untracked=0
  command git status --porcelain=v2 --branch 2>/dev/null | while IFS= read -r line; do
    case $line in
      '# branch.oid '*)  oid=${line#\# branch.oid } ;;
      '# branch.head '*) branch=${line#\# branch.head } ;;
      '? '*)             untracked=1 ;;
      'u '*)             unstaged=1 ;;
      '1 '*|'2 '*)
        x=${line[3]} y=${line[4]}
        [[ $x != . ]] && staged=1
        [[ $y != . ]] && unstaged=1 ;;
    esac
  done
  [[ -z $branch ]] && return
  [[ $branch == '(detached)' ]] && branch=${oid[1,7]}
  local out="%F{blue}(%f%F{red}${branch//\%/%%}%f%F{blue})%f"
  (( unstaged )) && out+=" %F{yellow}*%f"
  (( staged ))   && out+="%F{cyan}+%f"
  (( untracked )) && out+="%F{cyan}!%f"
  print -r -- $out
}

# zle -F handler: reads the segment, closes its own fd and redraws the prompt.
# A result from an older job is dropped, so it can't overwrite a newer one
function _prompt_git_done {
  local fd=$1 line
  IFS= read -r -u $fd line
  # The group scopes the redirect, zsh may already have removed the handler
  { zle -F $fd; exec {fd}<&- } 2>/dev/null
  [[ $fd == $_prompt_git_fd ]] || return
  _prompt_git=$line
  zle && zle reset-prompt
}

# Called from precmd: starts the background job and registers the handler
function _prompt_git_start {
  local fd
  _prompt_git=
  exec {fd}< <(_prompt_git_segment)
  [[ -n $fd ]] || return
  _prompt_git_fd=$fd
  zle -F $fd _prompt_git_done
}
