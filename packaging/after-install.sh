#!/bin/bash

ln -fs /usr/local/lib/PACKAGE_PLACEHOLDER/photish /usr/local/bin/photish
chmod -R a+r /usr/local/lib/PACKAGE_PLACEHOLDER
chmod a+rw /usr/local/lib/PACKAGE_PLACEHOLDER/lib/vendor/Gemfile.lock
