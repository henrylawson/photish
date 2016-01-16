#!/bin/bash
set -xeuo pipefail

# install dependencies
sudo yum install perl-Image-ExifTool
sudo yum install ImageMagick

# install ruby version
rbenv update > /dev/null
rbenv --version
if [ $RUBY_IS_CACHED == "1" ]
then
  rbenv download $RUBY_VERSION
else
  rbenv download 2.2.4
  eval "$(rbenv init -)"
  rbenv shell 2.2.4
  rbenv global 2.2.4
  gem install bundler
  rbenv install $RUBY_VERSION
fi
eval "$(rbenv init -)"
rbenv shell $RUBY_VERSION

ruby --version
gem --version

# setup bundler
gem install bundler
bundle --version
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
