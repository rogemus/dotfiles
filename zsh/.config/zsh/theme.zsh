#!/bin/bash

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BOLD=$(tput bold)
NORMAL=$(tput sgr0)

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr "${BOLD}${YELLOW} *${NORMAL}"
zstyle ':vcs_info:*' stagedstr "${BOLD}${GREEN} +${NOMAL}"
zstyle ':vcs_info:git:*' formats       "${BOLD}${WHITE}(${CYAN}%b${NORMAL}%u%c${BOLD}${WHITE})${NORMAL}"
zstyle ':vcs_info:git:*' actionformats '%b|%a%u%c'

precmd() {
  vcs_info
}

zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep -q '^?? ' 2> /dev/null ; then
        hook_com[staged]+="${BOLD}${RED}!${NOMAL}"
    fi
}

setopt prompt_subst

vsc() {
  echo "${vcs_info_msg_0_} "
}

directory() {
    echo "${BOLD}${GREEN}%1~ %#${NORMAL} "
}

arrow() {
  echo "${BOLD}${WHITE}-> ${NORMAL}" 
}

PS1="%2~% $(vsc)$(arrow)"

RPROMPT=""
