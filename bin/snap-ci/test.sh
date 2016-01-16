#!/bin/bash
set -xeuo pipefail

# install dependencies
sudo yum install perl-Image-ExifTool
sudo yum install ImageMagick

# install ruby version
rbenv update > /dev/null
if [ $RUBY_IS_CACHED == "1" ]
then
  rbenv download $RUBY_VERSION
else
  rbenv install $RUBY_VERSION
fi
rbenv global $RUBY_VERSION

# setup bundler
gem install bundler
rbenv rehash
bundle config path $SNAP_CACHE_DIR/gems/$RUBY_VERSION
bundle install

# run tests
if [ $SOFT_FAILURE == "1" ]
then
  bundle exec rake || true
else
  bundle exec rake
fi