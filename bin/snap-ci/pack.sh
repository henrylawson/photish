#!/bin/bash
set -xeuo pipefail

# map values from snap-ci
export COMMIT=$SNAP_COMMIT
export BRANCH=$SNAP_BRANCH
export TEMP_DIR=$SNAP_CACHE_DIR

# determine script dir
DIR="$(dirname "$(readlink -f "$0")")"

# setup dependencies and ruby
source "$DIR/setup.sh"

# build and package
bundle exec rake clean pack
