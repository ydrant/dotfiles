#!/bin/sh

sudo apt-get install curl python-setuptools 

curl https://raw.github.com/pypa/pip/master/contrib/get-pip.py | sudo python

sudo pip install pyflakes

mkdir -p ~/tmp/vim

ln -s ${PWD}/vim ~/.vim
ln -s ${PWD}/vim/vimrc ~/.vimrc

ln -s ${PWD}/bin ~/bin

ln -s ${PWD}/zsh ~/.zsh
ln -s ${PWD}/zsh/zshrc ~/.zshrc

