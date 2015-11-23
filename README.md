# Photish

Photish is a simple, convention based (but configurable) static photo site
generator tool. Photish allows you to order and group your photo collections
by folder, metadata can be written along side the photo in a YAML file
with the same name as the photo, just ending the file with `.yml`.

Photish will crawl through your directory of photos and pass the information
to your website templates. Using your templates, Photish creates a complete
static website that can be hosted on an NGINX or Apache web server.

## Installation

Install the gem locally by running:

    $ gem install photish

Alternatively, use [Bundler](http://bundler.io/). Create a folder for your
photo site so you can track the version of Photish you are building with:

    $ mkdir my_new_photo_site
    $ cd my_new_photo_site
    $ bundle init
    $ echo 'gem "photish"' >> Gemfile
    $ bundle install

## Usage

Once you have photish installed. Get started with the following commands:

### Creating a base site

TODO: Text here

### Important Concepts

TODO: Text here

#### Collection

TODO: Text here

#### Albums

TODO: Text here

#### Photos

TODO: Text here

#### Images

TODO: Text here

### Generate

TODO: Text here

TODO: Text here

### Host

TODO: Text here

## Development

To develop:

    $ git clone git@github.com:henrylawson/photish.git
    $ cd photish
    $ ./bin/setup     # installs dependencies
    $ rake            # runs the tests
    $ vim             # open up the project and begin contributing
    $ ./bin/console   # for an interactive prompt

To release:

    $ git add -p && git commit -m 'Final commit'    # finish up changes
    $ rake                                          # ensure all tests pass
    $ vim lib/photish/version.rb                    # update version
    $ rake release                                  # release to rubygems

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/henrylawson/photish. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).

