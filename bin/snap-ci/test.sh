#!/bin/bash
set -xeuo pipefail

# install dependencies
sudo yum install perl-Image-ExifTool
sudo yum install ImageMagick

# update rbenv
rbenv update > /dev/null
rbenv --version

# install ruby
rbenv download $RUBY_VERSION
eval "$(rbenv init -)"
rbenv shell $RUBY_VERSION
ruby --version
gem --version

# install bundler
gem install bundler
bundle --version

# configure bundler
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
