#!/bin/bash
set -xeuo pipefail

# install local package
cp /photish/pkg/*i386.rpm ~
sudo rpm -e photish || true
sudo rpm -Uh ~/*i386.rpm
photish version

# uninstall
sudo rpm -e photish

# download repo file
wget https://bintray.com/henrylawson/rpm/rpm -O bintray-henrylawson-rpm.repo
sudo mv bintray-henrylawson-rpm.repo /etc/yum.repos.d/
sudo yum install -y photish
photish version
