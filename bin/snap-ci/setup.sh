#!/bin/bash
set -xeuo pipefail

# map values from snap-ci
export CACHE_DIR=$SNAP_CACHE_DIR

# install dependencies
sudo yum install perl-Image-ExifTool
sudo yum install ImageMagick

# update rbenv
rbenv update > /dev/null
rbenv --version
eval "$(rbenv init -)"

# install ruby
rbenv download $RUBY_VERSION
rbenv shell $RUBY_VERSION
ruby --version

# configure bundler
rbenv rehash
bundle config path $CACHE_DIR/gems/$RUBY_VERSION
gem update --system
gem --version

# install bundler
gem install bundler
bundle --version

# install gems
bundle install
