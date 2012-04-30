#!/bin/sh

(cd deps/pyflakes && sudo python setup.py install)

ln -s ${PWD}/vim ~/.vim
ln -s ${PWD}/vim/vimrc ~/.vimrc

