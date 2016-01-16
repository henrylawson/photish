#!/bin/bash
set -xeuo pipefail

# map values from snap-ci
export COMMIT=$SNAP_COMMIT
export BRANCH=$SNAP_BRANCH

# determine script dir
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi

# setup dependencies and ruby
source "$DIR/setup.sh"

# conditionally release app
if git describe --exact-match $COMMIT && [ $BRANCH = 'master' ]
then
  bundle exec rake build release:rubygem_push release:github
else
  echo "This is not a tagged commit on master, skipping release."
fi
