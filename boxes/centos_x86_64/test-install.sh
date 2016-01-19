#!/bin/bash
set -xeuo pipefail

cp /photish/pkg/*x86_64.rpm ~
sudo rpm -e photish || true
sudo rpm -Uh ~/*x86_64.rpm
photish version
