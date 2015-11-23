# Photish

Photish is a simple, convention based (but configurable) static photo site
generator. Photish allows you to order and group your photo collections by
folder. Metadata can be written along side the photo in a
[YAML](http://yaml.org/) file with the same name as the photo.

Photish will crawl through your directory of photos and metadata, and render
the information in your website templates. Photish supports all template
engines implemented by [Tilt](https://github.com/rtomayko/tilt) (currently over
30 formats). It will also read your configuration and automatically convert
your images to your configured size, dimensions, colourscheme, etc using
[ImageMagick](http://www.imagemagick.org/script/index.php). Using this
information, Photish creates a complete static website that can be hosted on an
[NGINX](http://nginx.org/), [Apache HTTP Server](https://httpd.apache.org/), or
even on [Github Pages](https://pages.github.com/).

## Overview

Photish turns this:

    ./my_new_photo_site
    ├── config.yml
    ├── photos
    │   ├── Big Dogs
    │   │   ├── Tired Dogs.jpg
    │   │   └── Winking Dog.jpg
    │   └── Small Dogs
    │       ├── Fluffy Dogs
    │       │   ├── Exhausted Dogs.jpg
    │       │   ├── Exhausted Dogs.yml
    │       │   ├── Many Dogs.jpg
    │       │   └── Many Dogs.yml
    │       ├── Sleepy Dog.jpg
    │       ├── Sleepy Dog.yml
    │       └── Squishy Dogs
    │           └── Big Ear Dog.jpg
    └── site
        ├── _templates
        │   ├── album.slim
        │   ├── collection.slim
        │   ├── layout.slim
        │   └── photo.slim
        ├── custom.html
        └── styles
            └── basic.css

Into this:

    ./my_new_photo_site
    └── output
        ├── big-dogs
        │   ├── index.html
        │   ├── tired-dogs
        │   │   ├── images
        │   │   │   ├── tired-dogs-low.jpg
        │   │   │   └── tired-dogs-original.jpg
        │   │   └── index.html
        │   └── winking-dog
        │       ├── images
        │       │   ├── winking-dog-low.jpg
        │       │   └── winking-dog-original.jpg
        │       └── index.html
        ├── custom.html
        ├── index.html
        ├── small-dogs
        │   ├── fluffy-dogs
        │   │   ├── exhausted-dogs
        │   │   │   ├── images
        │   │   │   │   ├── exhausted-dogs-low.jpg
        │   │   │   │   └── exhausted-dogs-original.jpg
        │   │   │   └── index.html
        │   │   ├── index.html
        │   │   └── many-dogs
        │   │       ├── images
        │   │       │   ├── many-dogs-low.jpg
        │   │       │   └── many-dogs-original.jpg
        │   │       └── index.html
        │   ├── index.html
        │   ├── sleepy-dog
        │   │   ├── images
        │   │   │   ├── sleepy-dog-low.jpg
        │   │   │   └── sleepy-dog-original.jpg
        │   │   └── index.html
        │   └── squishy-dogs
        │       ├── big-ear-dog
        │       │   ├── images
        │       │   │   ├── big-ear-dog-low.jpg
        │       │   │   └── big-ear-dog-original.jpg
        │       │   └── index.html
        │       └── index.html
        └── styles
            └── basic.css

A breakdown of the before and after is as follows:

1. For the **Collection** of photos in "Photos" an _index.html_ was created
1. For each **Album** (that is a folder in the "Photos" collection), an
   _index.html_ was created in a slugified sub folder
1. For each **Photo** (an image file in the album), another _index.html_ was
   created in a slugified sub folder named after the original photo
1. For each of these Photos, a version of the **Image** was made in both "low"
   and "original" quality in a sub folder called _images_

The number of Images and the quality of each is completely configurable. Using
the templating language of your choice you can easily generate a Photo
collection driven website with all of your photos available in various
qualities.

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

### Initialize

A skeleton site can be created by running the below command inside the
`my_new_photo_site` folder:

    $ photish init

#### Basic Photish Structure

Inside your `my_new_photo_site` folder, you will have a:

1. `photos` folder, for your photo collection and metadata
1. `site` folder for your templates, assets and static pages
1. `site/_templates` folder for your templates
1. `site/_templates/layout.slim` file for the basic layout for all pages
1. `site/_templates/collection.slim` template file for your collection page
1. `site/_templates/album.slim` template file for your album page(s)
1. `site/_templates/photo.slim` template file for your photo page(s)
1. `config.yml` file to store all configuration in YAML format

#### Template Engines

By default Photish uses [Slim](http://slim-lang.com/) as the template language.
The templates can be in any format supported by
[Tilt](https://github.com/rtomayko/tilt). To use a different template language:

1. Create a `layout`, `collection`, `album` and `photo` file with
the file extension of the template engine you prefer
1. Update `config.yml` to reference your newly created template files
1. Re write the basic template code in your chosen language

### Generate

The static HTML can be generated by running the below command inside the
`my_new_photo_site` folder:

    $ photish generate

All generated content will be written to the `output` folder by default.

The Generate command does the following:

1. Crawls the `photos` directory for photos and metadata
1. Creates a site structure of Collection, Album(s), Photo(s) and Image(s)
1. Copies all files in the `site` folder **not** beginning with an `_`
   (underscore) to the `output` folder as these are viewed as "static" assets
1. Renders the HTML _index_ file(s) for the Collection, Album(s), Photo(s) and
   Image(s) to the `output` folder
1. Converts all Photo(s) to the configured quality versions, writing various
   images to the `output` folder

### Host

To test and view your changes locally, the host command can be used to run a
local
[WEBrick](http://ruby-doc.org/stdlib-1.9.3/libdoc/webrick/rdoc/WEBrick.html)
server to serve the HTML files:

    $ photish host

The local version of your website will be visible at [http://localhost:9876/](http://localhost:9876/)

### Customizing Templates

Below is the documentation for the various data available inside
each of the templates.

`{type}` is a place holder as depending on your chosen template engine
the file extension will change. By default the template engine is Slim, so
templates will end with _slim_.

#### Layout Template

**Default Location:** `site/_templates/layout.{type}`

TODO: Text here

#### Collection Template

**Default Location:** `site/_templates/collection.{type}`

TODO: Text here

#### Album Template

**Default Location:** `site/_templates/album.{type}`

TODO: Text here

#### Photo Template

**Default Location:** `site/_templates/photo.{type}`

TODO: Text here

## Development

If you would like to contribute to Photish by creating a new feature or fixing
bugs, you are more then welcome!

To develop:

    $ git clone git@github.com:henrylawson/photish.git
    $ cd photish
    $ ./bin/setup     # installs dependencies
    $ rake            # runs the tests
    $ vim             # open up the project and begin contributing
    $ ./bin/console   # for an interactive prompt

To release:

    $ git add -p                      # add in changed files
    $ git commit -m 'Final commit'    # finish up changes
    $ rake                            # ensure all tests pass
    $ vim lib/photish/version.rb      # update version
    $ rake release                    # release to rubygems

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/henrylawson/photish. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT
License](http://opensource.org/licenses/MIT).

