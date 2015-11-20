#!/usr/bin/env bash
if [[ "$EUID" -ne "0" && "$OSTYPE" != "darwin"* ]]; then
  echo "This script must be run as root on Linux." >&2
  exit 1
fi

if [[ $(ls /etc/*release 2>/dev/null | grep 'redhat' 2>/dev/null) != '' ]]; then
  echo "OS Detected: RedHat Linux"
  yum -y install yum-plugin-fastestmirror
  yum -y update
  yum -y groupinstall "Development tools"
  yum -y install openssl-devel readline-devel zlib-devel
  yum -y install git unzip wget
  yum -y install https://dl.bintray.com/mitchellh/vagrant/vagrant_1.7.4_x86_64.rpm
  if [[ $(cat /etc/redhat-release | grep ' 7') != '' ]]; then
    yum -y install http://download.virtualbox.org/virtualbox/5.0.8/VirtualBox-5.0-5.0.8_103449_el7-1.x86_64.rpm
  elif [[ $(cat /etc/redhat-release | grep ' 6') != '' ]]; then
    yum -y install http://download.virtualbox.org/virtualbox/5.0.8/VirtualBox-5.0-5.0.8_103449_el6-1.x86_64.rpm
  elif [[ $(cat /etc/redhat-release | grep ' 5') != '' ]]; then
    yum -y install http://download.virtualbox.org/virtualbox/5.0.8/VirtualBox-5.0-5.0.8_103449_el5-1.x86_64.rpm
  else
    echo 'ERROR: No appropriate VirtualBox package found'
  fi
elif [[ $(ls /etc/*release 2>/dev/null | grep 'lsb' 2>/dev/null) != '' ]]; then
  echo "OS Detected: Debian Linux"
  apt-get -y update
  apt-get -y upgrade
  apt-get -y install curl zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev
  apt-get -y install git-core unzip wget
  wget https://releases.hashicorp.com/vagrant/1.7.4/vagrant_1.7.4_x86_64.deb
  dpkg -i vagrant_1.7.4_x86_64.deb
  rm vagrant_1.7.4_x86_64.deb
  if [[ $(cat /etc/lsb-release | grep ' 15\.10') != '' ]]; then
    wget http://download.virtualbox.org/virtualbox/5.0.8/virtualbox-5.0_5.0.8-103449~Ubuntu~wily_amd64.deb
    dpkg -i virtualbox-5.0_5.0.8-103449~Ubuntu~wily_amd64.deb
    rm virtualbox-5.0_5.0.8-103449~Ubuntu~wily_amd64.deb
  elif [[ $(cat /etc/lsb-release | egrep ' (14|15\.04)') != '' ]]; then
    wget http://download.virtualbox.org/virtualbox/5.0.8/virtualbox-5.0_5.0.8-103449~Ubuntu~trusty_amd64.deb
    dpkg -i virtualbox-5.0_5.0.8-103449~Ubuntu~trusty_amd64.deb
    rm virtualbox-5.0_5.0.8-103449~Ubuntu~trusty_amd64.deb
  elif [[ $(cat /etc/lsb-release | grep ' 12') != '' ]]; then
    wget http://download.virtualbox.org/virtualbox/5.0.8/virtualbox-5.0_5.0.8-103449~Ubuntu~precise_amd64.deb
    dpkg -i virtualbox-5.0_5.0.8-103449~Ubuntu~precise_amd64.deb
    rm virtualbox-5.0_5.0.8-103449~Ubuntu~precise_amd64.deb
  else
    echo 'ERROR: No appropriate VirtualBox package found'
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "OS Detected: MacOS"

  # Install Brew
  if hash brew 2>/dev/null; then
    echo "Brew is already installed"
  else
    echo "Installing Brew"
    cd /usr/local
    mkdir homebrew && curl -L https://github.com/Homebrew/homebrew/tarball/master | tar xz --strip 1 -C homebrew
    ln -s /usr/local/homebrew/bin/brew /usr/local/bin/brew
  fi

  # Install Vagrant
  if hash vagrant 2>/dev/null; then
    echo "Vagrant is already installed"
  else
    echo "Installing Vagrant"
    brew install Caskroom/cask/vagrant --force
  fi


  # Install VirtualBox
  if hash vboxmanage 2>/dev/null; then
    echo "Virtualbox is already installed"
  else
    echo "Installing Virtualbox"
    brew install Caskroom/cask/virtualbox --force
    brew install Caskroom/cask/virtualbox-extension-pack --force
  fi

else
  echo "ERROR: Unsupported OS $OSTYPE"
fi
