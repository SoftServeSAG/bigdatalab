#!/usr/bin/env bash
VERSION=0.6.14

if [[ "$OSTYPE" == "linux"* ]]; then
  echo "OS Detected: Linux"

  if hash terraform 2>/dev/null; then
    echo "Terraform is already installed"
  else
    wget https://releases.hashicorp.com/terraform/${VERSION}/terraform_${VERSION}_linux_amd64.zip
    mkdir -p $HOME/.terraform
    unzip terraform_${VERSION}_linux_amd64.zip -d $HOME/.terraform
    rm terraform_${VERSION}_linux_amd64.zip
    if [[ $(grep 'export PATH="$HOME/.terraform:$PATH"' $HOME/.bashrc) == '' ]]; then
      echo 'export PATH="$HOME/.terraform:$PATH"' >> $HOME/.bashrc
    fi
  fi

elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "OS Detected: MacOS"  

  if hash terraform 2>/dev/null; then
    echo "Terraform is already installed"
  else
    brew install terraform
  fi

else
  echo "ERROR: Unsupported OS $OSTYPE"
  exit 1
fi

echo "Done!"
