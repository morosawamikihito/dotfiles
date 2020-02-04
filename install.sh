#!/bin/bash

##### requires #####
# - zsh
# - prezto
# - vim
# - peco
# - fzf
# - tmux
# - git
# - docker
# - kubectl
#######
# - anyenv
# - gcloud
# - aws

declare -a files=(
  ".bash_profile"
  ".bashrc"
  ".zshrc"
  ".organization.zsh"
  ".individual.zsh"
  ".gitconfig"
  ".gitignore"
  ".tmux.conf"
  ".vimrc"
)

function makeLink {
  for file in ${files[@]}; do
    if [ -f ${HOME}/${file} ]; then
      echo ${file} is already exists file
      continue
    fi
    if [ -L ${HOME}/${file} ]; then
      echo ${file} is already exists link
      continue
    fi
    ln -s ${HOME}/dotfiles/${file} ${HOME}/${file}
  done
}

function removeLink {
  for file in ${files[@]}; do
    if [ -L ${HOME}/${file} ]; then unlink ${HOME}/${file}; fi
  done
}

case $1 in
  force)
    removeLink
    makeLink
    ;;
  *) makeLink ;;
esac
