#!/usr/bin/env bash
VERSION=0.6.6

if [[ "$OSTYPE" == "linux"* ]]; then
  echo "OS Detected: Linux"

  if hash terraform 2>/dev/null; then
    echo "Terraform is already installed"
  else
    echo "Installing Terraform"
    wget https://dl.bintray.com/mitchellh/terraform/terraform_${VERSION}_linux_amd64.zip
    mkdir $HOME/.terraform
    unzip terraform_${VERSION}_linux_amd64.zip -d $HOME/.terraform
    rm terraform_${VERSION}_linux_amd64.zip
    echo 'export PATH="$HOME/.terraform:$PATH"' >> $HOME/.bashrc
  fi
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "OS Detected: MacOS"  

  # Install Terraform 
  if hash terraform 2>/dev/null; then
    echo "Terraform is already installed"
  else
    echo "Installing Terraform"
    brew install terraform
  fi
fi
