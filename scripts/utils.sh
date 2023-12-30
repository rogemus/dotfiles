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

info() {
  printf "${CYAN}$1${NORMAL}\n"
}

success() {
  printf "${BOLD}${GREEN}$1${NORMAL}\n"
}

banner() {
  info "################################################################################"
  info "$1"
  info "################################################################################"
  printf "\n"
}

