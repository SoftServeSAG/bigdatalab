#!/usr/bin/env bash
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
