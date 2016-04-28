#!/usr/bin/env bash
if [[ "$EUID" -ne "0" && "$OSTYPE" != "darwin"* ]]; then
  echo "This script must be run as root" >&2
  exit 1
fi

if [[ $(ls /etc/*release 2>/dev/null | grep 'redhat' 2>/dev/null) != '' ]]; then
  echo "OS Detected: RedHat Linux"

  if [[ $(cat /etc/redhat-release | egrep ' [67]') == '' ]]; then
    echo "ERROR: Unsupported RedHat Linux version (only 6.x and 7.x are currently supported)"
    exit 1
  fi

  # Install common packages
  yum -y install yum-plugin-fastestmirror
  yum -y update
  yum -y groupinstall "Development tools"
  yum -y install openssl-devel readline-devel zlib-devel
  yum -y install curl git unzip wget python-pip

  # Install Vagrant
  if [[ $(yum list | grep 'vagrant_1.8.1') == '' ]]; then
    yum -y install https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.rpm
  else
    echo 'Vagrant is already installed'
  fi

  # Install VirtualBox
  if [[ $(yum list | grep 'VirtualBox-5.0-5.0.8') == '' ]]; then
    if [[ $(cat /etc/redhat-release | grep ' 7') != '' ]]; then
      yum -y install http://download.virtualbox.org/virtualbox/5.0.8/VirtualBox-5.0-5.0.8_103449_el7-1.x86_64.rpm
    else
      yum -y install http://download.virtualbox.org/virtualbox/5.0.8/VirtualBox-5.0-5.0.8_103449_el6-1.x86_64.rpm
    fi
  else
    echo 'VirtualBox is already installed'
  fi

  # Install Python packages
  pip2 install --upgrade pip setuptools
  pip2 install -r requirements.txt

  # Install Ruby
  if [[ $(yum list | grep 'ruby-2.2.4-1') == '' ]]; then
    if [[ $(cat /etc/redhat-release | grep ' 7') != '' ]]; then
      yum -y install https://github.com/feedforce/ruby-rpm/releases/download/2.2.4/ruby-2.2.4-1.el7.centos.x86_64.rpm
    else
      yum -y install https://github.com/feedforce/ruby-rpm/releases/download/2.2.4/ruby-2.2.4-1.el6.x86_64.rpm
    fi
  else
    echo 'Ruby is already installed'
  fi
  if [[ $(yum list | grep 'ruby-debuginfo-2.2.4-1') == '' ]]; then
    if [[ $(cat /etc/redhat-release | grep ' 7') != '' ]]; then
      yum -y install https://github.com/feedforce/ruby-rpm/releases/download/2.2.4/ruby-debuginfo-2.2.4-1.el7.centos.x86_64.rpm
    else
      yum -y install https://github.com/feedforce/ruby-rpm/releases/download/2.2.4/ruby-debuginfo-2.2.4-1.el6.x86_64.rpm
    fi
  else
    echo 'Ruby DebugInfo is already installed'
  fi
  gem install bundler -v 1.10.5

elif [[ $(ls /etc/*release 2>/dev/null | grep 'lsb' 2>/dev/null) != '' ]]; then
  echo "OS Detected: Debian Linux"

  if [[ $(cat /etc/lsb-release | egrep ' 1[245]') == '' ]]; then
    echo "ERROR: Unsupported Debian Linux version (only 12.x, 14.x and 15.x are currently supported)"
    exit 1
  fi

  # Install common packages
  apt-get -y update
  apt-get -y upgrade

  if [[ $(cat /etc/lsb-release | egrep ' 1[45]') != '' ]]; then
    apt-get -y install software-properties-common
  else
    apt-get -y install python-software-properties
  fi

  apt-get -y install build-essential curl sqlite3 git-core unzip wget python-pip
  apt-get -y install zlib1g-dev libssl-dev libreadline-dev libyaml-dev libpython2.7-dev libsqlite3-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev libsdl1.2debian
  apt-get -y install ruby2.2-dev

  # Install Vagrant
  if [[ $(dpkg -l | egrep '^i' | egrep 'vagrant\s+1:1.8.1') == '' ]]; then
    wget https://releases.hashicorp.com/vagrant/1.8.1/vagrant_1.8.1_x86_64.deb
    dpkg -i vagrant_1.8.1_x86_64.deb
    rm vagrant_1.8.1_x86_64.deb
  else
    echo 'Vagrant is already installed'
  fi

  # Install VirtualBox
  if [[ $(dpkg -l | egrep '^i' | egrep 'virtualbox-5.0\s+5.0.8') == '' ]]; then
    if [[ $(cat /etc/lsb-release | grep ' 15\.10') != '' ]]; then
      wget http://download.virtualbox.org/virtualbox/5.0.8/virtualbox-5.0_5.0.8-103449~Ubuntu~wily_amd64.deb
      dpkg -i virtualbox-5.0_5.0.8-103449~Ubuntu~wily_amd64.deb
      rm virtualbox-5.0_5.0.8-103449~Ubuntu~wily_amd64.deb
    elif [[ $(cat /etc/lsb-release | egrep ' (14|15\.04)') != '' ]]; then
      wget http://download.virtualbox.org/virtualbox/5.0.8/virtualbox-5.0_5.0.8-103449~Ubuntu~trusty_amd64.deb
      dpkg -i virtualbox-5.0_5.0.8-103449~Ubuntu~trusty_amd64.deb
      rm virtualbox-5.0_5.0.8-103449~Ubuntu~trusty_amd64.deb
    else
      wget http://download.virtualbox.org/virtualbox/5.0.8/virtualbox-5.0_5.0.8-103449~Ubuntu~precise_amd64.deb
      dpkg -i virtualbox-5.0_5.0.8-103449~Ubuntu~precise_amd64.deb
      rm virtualbox-5.0_5.0.8-103449~Ubuntu~precise_amd64.deb
    fi
  else
    echo 'VirtualBox is already installed'
  fi

  # Install Python packages
  pip2 install --upgrade pip setuptools
  pip2 install -r requirements.txt

  # Install Ruby
  apt-add-repository -y ppa:brightbox/ruby-ng
  apt-get -y update
  apt-get -y install ruby2.2=2.2.4-1*
  gem install bundler -v 1.10.5

elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "OS Detected: MacOS"

  # Install Brew
  if hash brew 2>/dev/null; then
    echo "Brew is already installed"
  else
    cd /usr/local
    mkdir homebrew && curl -L https://github.com/Homebrew/homebrew/tarball/master | tar xz --strip 1 -C homebrew
    ln -s /usr/local/homebrew/bin/brew /usr/local/bin/brew
  fi

  # Install Vagrant
  if hash vagrant 2>/dev/null; then
    echo "Vagrant is already installed"
  else
    brew install Caskroom/cask/vagrant --force
  fi

  # Install VirtualBox
  if hash vboxmanage 2>/dev/null; then
    echo "VirtualBox is already installed"
  else
    brew install Caskroom/cask/virtualbox --force
    brew install Caskroom/cask/virtualbox-extension-pack --force
  fi

  # Install Python packages
  pip2 install --upgrade pip setuptools
  pip2 install -r requirements.txt

  # Install Ruby
  if hash rbenv 2>/dev/null; then
    echo "Ruby is already installed"
  else
    brew install rbenv ruby-build
    echo 'if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi' >> ~/.bash_profile
    source ~/.bash_profile
    rbenv install -v 2.2.4
    rbenv global 2.2.4
  fi
  gem install bundler -v 1.10.5

else
  echo "ERROR: Unsupported OS $OSTYPE"
  exit 1
fi

echo "Done!"
