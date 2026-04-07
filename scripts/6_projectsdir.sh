#!/bin/zsh

source ./utils.sh 

create_project_dir() {
  info "Creating projects directory..."
  mkdir ~/Developer
}

create_random_dir() {
  info "Creating random directory..."
  mkdir ~/Developer/random
}

create_project_dir
create_random_dir
