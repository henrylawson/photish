#!/bin/bash
set -xeuo pipefail

# map values from snap-ci
export COMMIT=$SNAP_COMMIT
export BRANCH=$SNAP_BRANCH

# conditionally release app
rbenv shell $RUBY_VERSION
if git describe --exact-match $COMMIT && [ $BRANCH = 'master' ]
then
  bundle exec rake build release:rubygem_push
else
  echo "This is not a tagged commit, skipping release."
fi
