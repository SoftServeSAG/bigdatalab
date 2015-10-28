#!/usr/bin/env bash
wget https://dl.bintray.com/mitchellh/terraform/terraform_0.6.4_linux_amd64.zip
mkdir $HOME/.terraform
unzip terraform_0.6.4_linux_amd64.zip -d $HOME/.terraform
rm terraform_0.6.4_linux_amd64.zip
echo 'export PATH="$HOME/.terraform:$PATH"' >> $HOME/.bashrc
