#!/bin/bash
set -xeuo pipefail

DIR=$( cd $(dirname $0) ; pwd -P )

cd $DIR/centos_i386   && vagrant up && vagrant provision
cd $DIR/centos_x86_64 && vagrant up && vagrant provision
cd $DIR/ubuntu_amd64  && vagrant up && vagrant provision
cd $DIR/ubuntu_i386   && vagrant up && vagrant provision
