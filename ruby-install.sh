#!/usr/bin/env bash

if [[ "$OSTYPE" == "linux"* ]]; then
  echo "OS Detected: Linux"
  rm -rf ~/.rbenv
  git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
  git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build

  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
  echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
  echo 'cd $HOME' >> ~/.bashrc
  echo 'eval "$(rbenv init -)"' >> ~/.bashrc

  export PATH="$HOME/.rbenv/bin:$PATH"
  export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"
  eval "$(rbenv init -)"

  rbenv install -v 2.2.2
  rbenv global 2.2.2
  gem install bundler -v 1.10.5

  OLD_DIR=$(pwd)
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  cd $DIR/puppet
  bundle install
  cd $OLD_DIR
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "OS Detected: MacOS"  

  # Install Ruby
  if hash rbenv 2>/dev/null; then
    echo "Ruby is already installed"
  else
    echo "Installing Ruby"

     brew install rbenv ruby-build

     # Add rbenv to bash so that it loads every time you open a terminal
     echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
     source ~/.bash_profile

     # Install Ruby
     rbenv install 2.2.3
     rbenv global 2.2.3
     ruby -v
  fi


  echo "Installing required Gems"
  OLD_DIR=$(pwd)
  DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
  cd $DIR/puppet
  bundle install
  cd $OLD_DIR

fi
