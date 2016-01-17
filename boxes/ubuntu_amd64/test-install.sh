#!/bin/bash
set -x

cp /photish/pkg/*amd64.deb ~
sudo dpkg -r photish
sudo dpkg -i ~/*amd64.deb
photish version
