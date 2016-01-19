#!/bin/bash
set -xeuo pipefail

cp /photish/pkg/*i386.rpm ~
sudo rpm -e photish
sudo rpm -Uh ~/*i386.rpm
photish version
