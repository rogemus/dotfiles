#!/bin/zsh

source ./utils.sh 

create_project_dir() {
  info "Creating projects directory..."
  mkdir ~/Desktop/Projects
}

create_random_dir() {
  info "Creating random directory..."
  mkdir ~/Desktop/Projects/random
}

create_project_dir
create_random_dir
