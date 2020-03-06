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

function make_link {
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

function remove_link {
  for file in ${files[@]}; do
    if [ -L ${HOME}/${file} ]; then unlink ${HOME}/${file}; fi
  done
}

function install_third_party {
  # requires
  #/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
  #brew install wget
  #brew install git
  # Todo: install requires software and refactor 

  # NeoBundle
  # mkdir -p ~/.vim/bundle
  # git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim

  # dein
}


case $1 in
  force)
    remove_link
    make_link
    ;;
  3rd) install_third_party ;;
  *) make_link ;;
esac


