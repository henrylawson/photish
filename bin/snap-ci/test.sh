#!/bin/bash
set -xeuo pipefail

# set default values
: ${SOFT_FAILURE:=0}
: ${SMOKE_TEST_ONLY:=0}
: ${COVERAGE:=0}
: ${PROFILE:=0}

# determine script dir
DIR="$(dirname "$(readlink -f "$0")")"

# setup dependencies and ruby
source "$DIR/setup.sh"

# run tests
if [ $SOFT_FAILURE == "1" ]
then
  bundle exec rake || true
else
  bundle exec rake
fi
