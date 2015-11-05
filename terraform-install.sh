#!/usr/bin/env bash
VERSION=0.6.6
wget https://dl.bintray.com/mitchellh/terraform/terraform_${VERSION}_linux_amd64.zip
mkdir $HOME/.terraform
unzip terraform_${VERSION}_linux_amd64.zip -d $HOME/.terraform
rm terraform_${VERSION}_linux_amd64.zip
echo 'export PATH="$HOME/.terraform:$PATH"' >> $HOME/.bashrc
