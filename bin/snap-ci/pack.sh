#!/bin/bash
set -xeuo pipefail

# map values from snap-ci
export TEMP_DIR=$SNAP_CACHE_DIR
export WORKING_DIR=$SNAP_WORKING_DIR

# determine script dir
DIR="$(dirname "$(readlink -f "$0")")"

# setup dependencies and ruby
source "$DIR/setup.sh"

# build and package
bundle exec rake clean pack

ls -larth ./pkg
