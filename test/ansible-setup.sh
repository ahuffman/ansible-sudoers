#!/bin/sh
set -e

## This is an example setup script that you would encapsulate the installation
# What version of avm setup to use
echo "Setting up Ansible Version Manager"
AVM_VERSION="v1.0.0-rc.8"
## Install Ansible 1.9.6 using pip and label it 'v1.9'
export ANSIBLE_VERSIONS_0="1.9.6"
export INSTALL_TYPE_0="pip"
export ANSIBLE_LABEL_0="v1.9"
## Install Ansible 2.2.1 using pip and label it 'v2.2'
export ANSIBLE_VERSIONS_1="2.2.1.0"
export INSTALL_TYPE_1="pip"
export ANSIBLE_LABEL_1="v2.2"
## Install Ansible 2.3.1 using pip and label it 'v2.3'
export ANSIBLE_VERSIONS_2="2.3.1.0"
export INSTALL_TYPE_2="pip"
export ANSIBLE_LABEL_2="v2.3"
# Whats the default version
ANSIBLE_DEFAULT_VERSION="v2.3"

## Create a temp dir to download avm
avm_dir="$(mktemp -d 2> /dev/null || mktemp -d -t 'mytmpdir')"
git clone https://github.com/ahelal/avm.git "${avm_dir}" > /dev/null 2>&1

## Run the setup
/bin/sh ${avm_dir}/setup.sh

exit 0
