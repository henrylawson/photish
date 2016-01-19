#!/bin/bash
set -xeuo pipefail

# map values from snap-ci
export COMMIT=$SNAP_COMMIT
export BRANCH=$SNAP_BRANCH

# determine script dir
DIR="$(dirname "$(readlink -f "$0")")"

# setup dependencies and ruby
source "$DIR/setup.sh"

ls -lrt ./pkg

# conditionally release app
if git describe --exact-match $COMMIT && [ $BRANCH = 'master' ]
then
  bundle exec rake release
else
  echo "This is not a tagged commit on master, skipping release."
fi
