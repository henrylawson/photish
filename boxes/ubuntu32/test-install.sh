#!/bin/bash
set -x

cp /photish/pkg/*i386.deb ~
sudo dpkg -r photish
sudo dpkg -i ~/*i386.deb
photish version
