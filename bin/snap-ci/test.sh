#!/bin/bash
set -xeuo pipefail

# set default values
: ${SOFT_FAILURE:=0}
: ${SMOKE_TEST_ONLY:=0}
: ${COVERAGE:=0}
: ${PROFILE:=0}

# run tests
if [ $SOFT_FAILURE == "1" ]
then
  bundle exec rake || true
else
  bundle exec rake
fi
