#!/bin/bash
set -xeuo pipefail

DIR=$( cd $(dirname $0) ; pwd -P )

docker build -t "photish/ubuntu" $DIR/ubuntu
cd $DIR/ubuntu && docker run -t -i -v $PWD:/local -v $PWD/../../:/photish photish/ubuntu './local/test-install-amd64.sh'
cd $DIR/ubuntu && docker run -t -i -v $PWD:/local -v $PWD/../../:/photish photish/ubuntu './local/test-install-i386.sh'

docker build -t "photish/centos" $DIR/centos
cd $DIR/centos && docker run -t -i -v $PWD:/local -v $PWD/../../:/photish photish/centos './local/test-install-x86_64.sh'
cd $DIR/centos && docker run -t -i -v $PWD:/local -v $PWD/../../:/photish photish/centos './local/test-install-i386.sh'

echo "*** TEST COMPLETED SUCCESSFULLY ***"
