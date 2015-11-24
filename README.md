[![Gem Version](https://badge.fury.io/rb/photish.svg)](https://badge.fury.io/rb/photish)
[![Build Status](https://travis-ci.org/henrylawson/photish.svg)](https://travis-ci.org/henrylawson/photish)
[![Code Climate](https://codeclimate.com/github/henrylawson/photish/badges/gpa.svg)](https://codeclimate.com/github/henrylawson/photish)
[![Test Coverage](https://codeclimate.com/github/henrylawson/photish/badges/coverage.svg)](https://codeclimate.com/github/henrylawson/photish/coverage)
[![Issue Count](https://codeclimate.com/github/henrylawson/photish/badges/issue_count.svg)](https://codeclimate.com/github/henrylawson/photish/issues)
# Photish

Photish is a simple, convention based (but configurable) static photo site
generator. Photish allows you to group your photo collections by folder.
Metadata can be written alongside the photo in a [YAML](http://yaml.org/) file
with the same name as the photo.

Photish will crawl through your directory of photos and metadata, and render
the information in your website templates. Photish supports all template
engines implemented by [Tilt](https://github.com/rtomayko/tilt) (currently over
30 formats). It will also read your configuration and automatically convert
your images to your configured size, dimensions, colourscheme, etc using
[ImageMagick](http://www.imagemagick.org/script/index.php). Using this
information, Photish creates a complete static website that can be hosted on an
[NGINX](http://nginx.org/), [Apache HTTP Server](https://httpd.apache.org/), or
even on [Github Pages](https://pages.github.com/).

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
  - [Dependencies](#dependencies)
- [Usage](#usage)
  - [Initialize](#initialize)
    - [Basic Photish Structure](#basic-photish-structure)
    - [Template Engines](#template-engines)
    - [Site Assets](#site-assets)
    - [Config File Options](#config-file-options)
    - [Customizing Templates](#customizing-templates)
      - [Layout Template](#layout-template)
      - [Collection Template](#collection-template)
      - [Album Template](#album-template)
      - [Photo Template](#photo-template)
  - [Generate](#generate)
    - [Execution Order](#execution-order)
  - [Host](#host)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

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
qualities and formats.

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

### Dependencies

Photish has dependencies on certain utilities:

- [ImageMagick](http://www.imagemagick.org/script/index.php), for Image
  conversion
- [Exiftool](http://www.sno.phy.queensu.ca/~phil/exiftool/), for image metadata
  retrieval

**On MacOSX, using [Brew](http://brew.sh/)**

    $ brew install imagemagick
    $ brew install exiftool

**On Ubuntu or Debian**

    $ sudo apt-get install imagemagick
    $ sudo apt-get install libimage-exiftool-perl

## Usage

Once you have photish installed. Get started with the following commands:

### Initialize

A skeleton site can be created by running the below command inside the
`my_new_photo_site` folder:

    $ photish init

#### Basic Photish Structure

Inside your `my_new_photo_site` folder, you will have a:

File or Folder                    | Purpose
--------------------------------- | -------
`photos`                          | folder, for your photo collection and metadata
`site`                            | folder for your templates, assets and static pages
`site/_templates`                 | folder for your templates
`site/_templates/layout.slim`     | file for the basic layout for all pages
`site/_templates/collection.slim` | template file for your collection page
`site/_templates/album.slim`      | template file for your album page(s)
`site/_templates/photo.slim`      | template file for your photo page(s)
`config.yml`                      | file to store all configuration in YAML format

#### Template Engines

By default Photish uses [Slim](http://slim-lang.com/) as the template language.
The templates can be in any format supported by
[Tilt](https://github.com/rtomayko/tilt). To use a different template language:

1. Create a `layout`, `collection`, `album` and `photo` file with
the file extension of the template engine you prefer
1. Update `config.yml` to reference your newly created template files
1. Re write the basic template code in your chosen language

#### Site Assets

Any content not starting with an `_` (underscore) in the `site` folder will be
copied to the `output` folder.

In the example in the Overview section. There are 2 static asset files. These
are:

1. `site/styles/basic.css`
1. `site/custom.html`

Both of these files were copied by Photish to the output folder, respecting
their folder/file hierarchy:

1. `output/styles/basic.css`
1. `site/custom.html`

As documented in the Generate section, assets are copied before the site
content is generated. If an asset has a conflicting name and path with a
generated file, the generated file will clobber the asset.

#### Config File Options

Below is a basic `config.yml` file:

```yaml
port: 9876
qualities:
  - name: Original
    params: []
  - name: Low
    params: ['-resize', '200x200']
templates:
  layout: layout.slim
  collection: collection.slim
  album: album.slim
  photo: photo.slim
```

The meanings and purpose of each field is defined below:

Field                  | Purpose
---------------------- | -------
`port`                 | the port number that the `photish host` command will bind to
`qualities`            | an array of `name` and `params` fields for **Images**
`qualities[]/name`     | the name of the **Image** quality
`qualities[]/params`   | the parameters to be provided to the ImageMagick `convert` utility  for the **Image** file quality
`templates`            | a listing of the various template files
`templates/layout`     | the layout template file in the `site/_templates` folder
`templates/collection` | the collection template file in the `site/_templates` folder
`templates/album`      | the album template file in the `site/_templates` folder
`templates/photo`      | the photo template file in the `site/_templates` folder

#### Customizing Templates

Below is the documentation for the various data available inside
each of the templates.

**Note:** `{type}` is a place holder depending on your chosen template engine
the file extension will change. By default the template engine is
[Slim](http://slim-lang.com/), so templates will end with the _slim_ extension.

##### Layout Template

`site/_templates/layout.{type}`

The layout template is the base layout for all the other templates. The
`collection`, `album` and `photo` templates will be rendered inside this
layout. The layout template **must** include the `yield` statement to bind the
sub template inside it. Below is an example [Slim](http://slim-lang.com/)
template, the other templates will be bound where the `yield` statement is:

```slim
doctype html
html
  head
    title Master Layout
  body
    == yield
```

##### Collection Template

`site/_templates/collection.{type}`

The collection template becomes the `index.html` for the root of the website.

This template is passed the
[Collection](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/collection.rb)
model when rendered.

Attribute or Method | Description
------------------- | -----------
url                 | the URL of this page
metadata            | an object with methods for the attributes in the `photos.yml` file
all_albums          | an array of all child [Albums](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/album.rb)
all_photos          | an array of all child [Photos](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/photo.rb)
all_images          | an array of all child [Images](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/image.rb)

##### Album Template

`site/_templates/album.{type}`

For each folder in the `photos` directory, a slugified album folder is created
with an `index.html` in it.

This template is passed the
[Album](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/album.rb)
model when rendered.

Attribute or Method | Description
------------------- | -----------
name                | the name of the folder, i.e. `photos/My album/` will become `My album`
url                 | the URL of this page
metadata            | an object with methods for the attributes in the `{album_name}.yml` file stored at the same level as the album
all_albums          | an array of all child [Albums](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/album.rb)
all_photos          | an array of all child [Photos](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/photo.rb)
all_images          | an array of all child [Images](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/image.rb)

##### Photo Template

`site/_templates/photo.{type}`

For each image in an Albums directory, a slugified photo folder is created
with an `index.html` in it.

This template is passed the
[Photo](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/photo.rb)
model when rendered.

Attribute or Method | Description
------------------- | -----------
name                | the name of the photo, i.e. `photos/My album/My dog.jpg` will become `My dog`
url                 | the URL of this page
metadata            | an object with methods for the attributes in the `{photo_name}.yml` file stored at the same level as the photo
exif                | an object with methods for the exif data of the original photo file
images              | an array of all the [Images](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/image.rb) for this photo, an Image will be a version of the photo in the quality configured in `config.yml`

### Generate

The static HTML can be generated by running the below command inside the
`my_new_photo_site` folder:

    $ photish generate

All generated content will be written to the `output` folder by default.

#### Execution Order

The Generate command does the following:

1. Crawls the `photos` directory for photos and metadata
1. Creates a site structure of Collection, Album(s), Photo(s) and Image(s)
1. Copies all files in the `site` folder **not** beginning with an `_`
   (underscore) to the `output` folder as these are viewed as "static" assets.
   That is, folders like `_templates` are ignored
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

