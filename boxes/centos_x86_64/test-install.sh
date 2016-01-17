#!/bin/bash
set -x

cp /photish/pkg/*x86_64.rpm ~
sudo rpm -e photish
sudo rpm -Uh ~/*x86_64.rpm
photish version
