#!/bin/sh

which pip > /dev/null
if [ "$?" -ne "0" ]; then 
  sudo apt-get install curl python-setuptools 
  curl https://raw.github.com/pypa/pip/master/contrib/get-pip.py | sudo python
fi

sudo pip install -U pyflakes

# COMMON  FILES
if [ -e ~/bin ]; then 
  echo "~/bin already exists"
else
  echo "~/bin creating"
  ln -s ${PWD}/bin ~/bin
fi
mkdir -p ~/tmp/vim

echo "********** VIM **********"
if [ -e ~/.vim ]; then 
  echo "~/.vim already exists"
else
  echo "~/.vim creating"
  ln -s ${PWD}/vim ~/.vim
  ln -s ${PWD}/vim/vimrc ~/.vimrc
fi


echo "********** VIM **********"
if [ -e ~/.zsh ]; then 
  echo "~/.zsh already exists"
else
  echo "~/.zsh creating"
  ln -s ${PWD}/zsh ~/.zsh
  ln -s ${PWD}/zsh/zshrc ~/.zshrc
fi

