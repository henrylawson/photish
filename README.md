[![Gem Version](https://badge.fury.io/rb/photish.svg)](https://badge.fury.io/rb/photish)
[![Build Status](https://travis-ci.org/henrylawson/photish.svg)](https://travis-ci.org/henrylawson/photish)
[![Dependency Status](https://gemnasium.com/henrylawson/photish.svg)](https://gemnasium.com/henrylawson/photish)
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

Photish has been created with speed and efficiency in mind. Threads are used
to parallelize image transcoding to achieve maximum utilization of your CPU
during generation. A cache file is then used to ensure that unless the image
has changed, it is not needlessly regenerated. This results in a responsive
and fast local development environment, making it easy to perfect the design
of your photo based website without having to wait for regeneration.

## Photish in the Wild

1. [Photish Montage](https://foinq.com/photish-montage/index.html) - A quick
   mockup to show what can be done with Photish. [Source
   here](https://github.com/henrylawson/photish-montage).

## Getting Started

It is strongly recommended to read through the [Installation](#installation)
and [Usage](#usage) sections before seriously using Photish, however to get up
and running:

1. Ensure [ImageMagick](http://www.imagemagick.org/script/index.php) and
   [Exiftool](http://www.sno.phy.queensu.ca/~phil/exiftool/) are
   installed (see [Dependencies](#dependencies))
1. Install Photish `gem install photish`
1. Create a base project with `photish init --example`
1. Generate the HTML using `photish generate`
1. Run a local HTTP server to view the site with `photish host`
1. View your photo site at [http://localhost:9876](http://localhost:9876/)

# Documentation

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
      - [Template Helpers](#template-helpers)
  - [Generate](#generate)
    - [Execution Order](#execution-order)
    - [Workers and Threads](#workers-and-threads)
    - [Caching](#caching)
      - [Automatic Rengeneration](#automatic-regeneration)
      - [Forced Regeneration](#forced-regeneration)
    - [Crude Performance Measures](#crude-performance-measures)
  - [Host](#host)
  - [Deploy](#deploy)
  - [Rake Task](#rake-task)
  - [Plugins](#plugins)
    - [Template Helper Plugins](#template-helper-plugins)
    - [Deployment Engine Plugins](#deployment-engine-plugins)
    - [Plugin Loading](#plugin-loading)
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
        ├── images
        │   └── crumbs.gif
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
        ├── images
        │   └── crumbs.gif
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

Photish has dependencies on certain software:

- [Ruby](https://www.ruby-lang.org/en/) as the utility is written in Ruby and
  is a [Gem](https://www.ruby-lang.org/en/libraries/)
- [Bundler](http://bundler.io/) is not required but recommended to manage the
  version, installations and updates of the Photish gem
- [ImageMagick](http://www.imagemagick.org/script/index.php) for Image
  conversion
- [Exiftool](http://www.sno.phy.queensu.ca/~phil/exiftool/) for image metadata
  retrieval

Target OS dependencies:

- [Unix](http://www.unix.org/) based operating system, Photish has been tested
  thoroughly on Ubuntu and MacOSX

**On MacOSX, using [Brew](http://brew.sh/)**

    $ brew install ruby
    $ brew install imagemagick
    $ brew install exiftool
    $ gem install bundler

**On Ubuntu or Debian**

    $ sudo apt-add-repository ppa:brightbox/ruby-ng
    $ sudo apt-get update
    $ sudo apt-get install ruby2.2
    $
    $ sudo apt-get install imagemagick
    $ sudo apt-get install libimage-exiftool-perl

## Usage

Once you have photish installed. Get started with the following commands:

### Initialize

A skeleton site can be created by running the below command inside the
`my_new_photo_site` folder:

    $ photish init --example

A barebones site can be created with:

    $ photish init

#### Basic Photish Structure

Inside your `my_new_photo_site` folder, you will have a:

File or Folder                    | Purpose
--------------------------------- | -------
`photos`                          | folder, for your photo collection and metadata
`site`                            | folder for your templates, assets and static pages
`site/_plugins`                   | folder for plugins to be loaded from
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

1. Create a `layout`, `collection`, `album` and `photo` file in the
   `site/_templates` folder, with the file extension of the template engine you
   prefer, supported extensions are documented by
   [Tilt](https://github.com/rtomayko/tilt)
1. Update `config.yml` to reference your newly created template files
1. Re write the basic template code in your chosen language

#### Site Assets

Any content not starting with an `_` (underscore) in the `site` folder will be
copied to the `output` folder.

In the example in the Overview section. There are a few static asset files.
These are:

1. `site/styles/basic.css`
1. `site/images/crumbs.gif`
1. `site/custom.html`

Both of these files were copied by Photish to the output folder, respecting
their folder/file hierarchy:

1. `output/styles/basic.css`
1. `site/custom.html`

As documented in the Generate section, assets are copied before the site
content is generated. If an asset has a conflicting name and path with a
generated file, the generated file will clobber the asset.

#### Config File Options

The default way to express config is in the `config.yml` file. However config
can also be overridden using the `--config_override` flag to any of the Photish
commands. When using the `--config_override` flag, the config must be expressed
as [JSON](http://www.json.org/). For example, to override logging when calling
the Generate command, you can use:

    $ photish generate --config_override='{"logging":{"colorize":false}}'

This method of config override is only recommended for cases where the value
needs to be temporarily overridden, such as during a deployment or while
debugging.

Below is a complete `config.yml` file, recommended practice is to only set the
config values you need, otherwise just use the defaults, the file can be empty
and Photish will still function:

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
logging:
  colorize: true
  level: 'debug'
  output: ['stdout', 'file']
url:
  host: http://mydomain.com
  base: 'subdirectory'
  type: 'relative_uri'
workers: 4
threads: 2
force: false
plugins: ['ssh_deploy', 'other_plugin']
image_extensions: ['jpg', 'gif']
```

The meanings and purpose of each field is defined below:

Field                  | Purpose
---------------------- | -------
`port`                 | the port number that the `photish host` command will bind to, default is `9876`
`qualities`            | an array of `name` and `params` fields for **Images**
`qualities[]/name`     | the name of the **Image** quality
`qualities[]/params`   | the parameters to be provided to the ImageMagick `convert` utility  for the **Image** file quality
`templates`            | a listing of the various template files
`templates/layout`     | the layout template file in the `site/_templates` folder, must be overridden if using a different template engine
`templates/collection` | the collection template file in the `site/_templates` folder, must be overridden if using a different template engine
`templates/album`      | the album template file in the `site/_templates` folder, must be overridden if using a different template engine
`templates/photo`      | the photo template file in the `site/_templates` folder, must be overridden if using a different template engine
`logging`              | a listing of the various logging options
`logging/colorize`     | when outputting to `STDOUT`, `true` to use color, `false` for none
`logging/level`        | the default logging level, it is advised to keep this at `debug`, supported are `debug`, `info`, `warn`, `error` and `fatal`
`logging/output`       | the appenders for the logger, `stdout` goes to `STDOUT`, `file` goes to `log/photish.log`
`url`                  | a listing of the various url options
`url/host`             | if you would like URLs generated with a specific host prefix, you can define it here, otherwise leave it as '/' or do not set this configuration at all
`url/base`             | if your website will be hosted in a sub folder and will not be accessible at the root of the host, you can specify the sub folder(s) here, this will also mean your website will be hosted in a sub folder when ran using `photish host`
`url/type`             | if your website URLs require the host name in them, you can use `absolute_uri` (i.e. http://mysite.com/subdirectory/index.html), if you would prefer to generate URLs that end at the root, you can use `absolute_relative` (i.e. /subdirectory/index.html)
`workers`              | the number of workers to create, for computers with multiple processors, photish is configured by default to spawn a worker for each process, a worker is responsible for image generation and html generation, load balancing is done randomly via a simple round robin allocation
`threads`              | the number of threads each worker should create to handle image magick transcoding
`force`                | this should always be false, if true, all content will be regenerated and nothing cached
`plugins`              | an array of plugin names that have been included in your Gemfile and that Photish should require into it's runtime
`image_extensions`     | by default, Photish obtains a list of supported image format extensions from ImageMagick, however if you choose too, you can explicitly list the extensions that Photish should use to find images

#### Customizing Templates

Below is the documentation for the various data available inside
each of the templates.

**Note:** `{type}` is a place holder depending on your chosen template engine
the file extension will change. By default the template engine is
[Slim](http://slim-lang.com/), so templates will end with the _slim_ extension.

##### Layout Template

`site/_templates/layout.{type}`

Example:

```slim
doctype html
html
  head
    title Master Layout
  body
    == yield
```

The layout template is the base layout for all the other templates. The
`collection`, `album` and `photo` templates will be rendered inside this
layout. The layout template **must** include the `yield` statement to bind the
sub template inside it. Below is an example [Slim](http://slim-lang.com/)
template, the other templates will be bound where the `yield` statement is:

##### Collection Template

`site/_templates/collection.{type}`

Example:

```slim
h1 Photo Collection
- albums.each do |album|
  div.album
    div.album-title
      a href=album.url
        | #{album.name}
```

The collection template becomes the `index.html` for the root of the website.

This template is passed the
[Collection](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/collection.rb)
model when rendered.

Attribute or Method | Description
------------------- | -----------
url                 | the URL of this page
metadata            | an object with methods for the attributes in the `photos.yml` file
albums              | an array of child [Albums](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/album.rb) within this folder
all_albums          | an array of all child [Albums](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/album.rb)
all_photos          | an array of all child [Photos](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/photo.rb)
all_images          | an array of all child [Images](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/image.rb)

##### Album Template

`site/_templates/album.{type}`

Example:

```slim
h1 Album
h2
  a href=url
    | #{name}
div.album-photos
  - photos.each do |photo|
    div.album-photo
      a href=photo.url title=photo.name
        img src=photo.images.find{ |i|i.quality_name=='Low' }.url alt=photo.name
```

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
albums              | an array of child [Albums](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/album.rb) within this folder
all_albums          | an array of all child [Albums](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/album.rb)
all_photos          | an array of all child [Photos](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/photo.rb)
all_images          | an array of all child [Images](https://github.com/henrylawson/photish/blob/master/lib/photish/gallery/image.rb)

##### Photo Template

`site/_templates/photo.{type}`

Example:

```slim
h1 Photo
h2
  a href=url
    | #{name}
  div.album-photos
    - images.each do |image|
      div.album-photo
        a href=image.url title=image.name
          img src=image.url alt=image.quality_name
```

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

#### Template Helpers

A template helper is a simple method that is available in the template that can
be called to render complex information.

For example in a template, the method `breadcrumbs` can be called:

```slim
div.content
  div.site-breadcrumbs
    == breadcrumbs
```

When rendered this will result in an unordered list of pages above the
current page in the hierarchy:

```html
<div class="content">
  <div class="site-breadcrumbs">
    <ul class="breadcrumbs">
      <li class="breadcrumb crumb-0 crumb-first">
        <a href="/index.html">Home</a>
      </li>
      <li class="breadcrumb crumb-1">
        <a href="/big-dogs/index.html">Big Dogs</a>
      </li>
      <li class="breadcrumb crumb-2 crumb-last">
        <a href="/big-dogs/tired-dogs/index.html">Tired Dogs</a>
      </li>
    </ul>
  </div>
</div>
```

Custom template helpers are supported through [Plugins](#plugins).

By default, Photish comes with the following helpers:

Method              | Description
------------------- | -----------
breadcrumbs         | an unordered list of pages above the current page in the hierarchy
build_url(\*pieces) | use this to ensure your URLs have the correct host name and base directory, to avoid having it hard coded in the template

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

#### Workers and Threads

In order to achieve maximum utilization of all processors on a computer during
generation, Photish has the ability to create multiple workers and threads.

A worker is a spawned sub process created by the Generate command. The worker
sub process is responsible for generating the HTML and Images for a subset of
the collection.

Within each worker, threads are created when calling out to the Image Magick
binary. During conversion, Image Magick often does not reach full processor
utilization so rather then block the whole worker, it can be more performant to
spawn multiple Image Magick processes at once.

For collections with a large number of images and HTML pages, multiple workers
and threads can be used to rapidly speed up generation. However, if the
collection has a small number of photos and pages, workers and threads will
increase the generation time as loading a new ruby process and creating
multiple threads may have a higher setup time then just generating everything
in a single ruby process and thread.

The number of workers and threads is configurable in the [config
file](#config-file-options) with the `workers` and `threads` options. By
default, Photish will spawn a thread for each processor detected on the
computer. It will then run this on a single worker.

When configuring more than 1 worker, it is important to remember that each
worker will spawn their own set of threads, if 4 workers are created, each with
2 threads, it means in total Photish will manage 8 threads and potentially run
8 Image Magick processes concurrently.  When tweaking the number of workers and
threads it is important to consider IO bottlenecks as this will most likely be
the limiting factor in performance.

#### Caching

Photish caches the generation of images to avoid regeneration when the
Generate command is run or the generate event is triggered while hosting
a local version of Photish with the Host command.

The cache file is stored in the `output_dir` and is named `.changes.yml`.

##### Automatic Regeneration

Images are regenerated when a photo is modified, renamed or moved.

Changing the `qualities` option in the config file will also trigger a full
regeneration of all images.

##### Forced Regeneration

To do a full regeneration, run the Generate command with the `--force`
flag:

    $ photish generate --force

The host command also supports the `--force` flag, to do a full regeneration
on every change:

    $ photish host --force

### Crude Performance Measures

Below are some crude performance measures to get a ballpark idea of how
Photish performs when generating for a large collection.

**Benchmark Computer:**

    MacBook Pro (Retina, 13-inch, Early 2015)
    2.7 GHz Intel Core i5 (4 processors)
    8 GB 1867 MHz DDR3


Photos  | Size (M) | Workers   | Threads | Total Threads | Time (Seconds)
--------|----------|-----------|---------|---------------|----------------
934     | 464      | 1         | 1       | 1             | 601
934     | 464      | 2         | 1       | 2             | 367
934     | 464      | 4         | 1       | 4             | 312
934     | 464      | 8         | 1       | 8             | 328
934     | 464      | 1         | 2       | 2             | 346
934     | 464      | 1         | 4       | 4             | **288**
934     | 464      | 1         | 8       | 8             | 290
934     | 464      | 2         | 2       | 4             | 309

It is interesting to note the 20-30 second difference between using 4 workers
vs. 4 threads. The time difference is due to the setup time of creating a whole
new ruby process for each worker.

### Host

To test and view your changes locally, the host command can be used to run a
local
[WEBrick](http://ruby-doc.org/stdlib-1.9.3/libdoc/webrick/rdoc/WEBrick.html)
server to serve the HTML files:

    $ photish host

The local version of your website will be visible at
[http://localhost:9876/](http://localhost:9876/).

The Host command will also automatically regenerate the website on startup and
when a file is added, removed or modified in the `photo_dir` or `site_dir`.

Note, when running in this mode any Image Conversion errors are swallowed and
logged. This is done as it is quite common for image files to be moved while
conversion is in progress. Rather then terminate the Host, the file move is
recorded and regeneration will be triggered once the current generation
completes.

### Deploy

Photish provides a plugin type specifically for deployments, called the
[Deployment Engine](#deployment-engine-plugins). Once a deploy plugin is
configured, it can be ran by passing the deploy plugins name as a value with
the `engine` argument.

    $ photish deploy --engine=name

To utilize a Deployment Engine Plugin someone in the community has written,
take a look at [Plugin Loading](#plugin-loading) for how to include it in your
site.

If you would like to write a [Deployment Engine
Plugin](#deployment-engine-plugins) instructions are available in the [plugin
section](#deployment-engine-plugins).

### Rake Task

If you would prefer to use Photish as a task in
[Rake](http://rake.rubyforge.org/). A helper class is available to create
custom rake tasks that call Photish. The helper class is defined in
[Photish::Rake::Task](https://github.com/henrylawson/photish/blob/master/lib/photish/rake/task.rb).

In your Rakefile, simply add the following to wrap the generate command:

```ruby
Photish::Rake::Task.new(:generate, 'Compiles the project to HTML') do |t|
  t.options = "generate"
end
```

The above code will define a rake task called `generate` which can be ran
by using `rake generate`. It is the equivalent of `photish generate`.

### Plugins

Photish supports extension through the creation of plugins.

#### Template Helper Plugins

To create a template helper plugin you must:

1. Create a **Ruby Module** in the `Photish::Plugin` module namespace, if
   you are packaging the plugin as a Gem, you can implement your module one
   level deeper in the namespace to allow for the Gem namespace, e.g.
   `Photish::Plugin::MyGemPlugin::MyTemplateHelper`
1. Make the plugin available for [loading](#plugin-loading)
1. Implement the `self.is_for?(type)` method
1. Implement your custom helper method(s)

A simple plugin is bellow, this plugin is for all [Photo
Template](#photo-template)'s as the `self.is_for?(type)` method only returns
true for `Photish::Plugin::Type::Photo` types. When the `shout` method is
called inside the template, it will render the message in bold wrapped in the
"I am shouting" text.

**site/_plugins/shout.rb**
```ruby
module Photish::Plugin::Shout
  def self.is_for?(type)
    Photish::Plugin::Type::Photo == type
  end

  def shout(message)
    "<strong>I am shouting '#{message}'!!!</strong>"
  end
end

```
A Template Helper Plugin `self.is_for?(type)` method could potentially receive
any of the below types, simply return true for the types the Template Helper
Plugin supports:

1. `Photish::Plugin::Type::Collection`
1. `Photish::Plugin::Type::Album`
1. `Photish::Plugin::Type::Photo`
1. `Photish::Plugin::Type::Image`

To use the Template Helper Plugin, simply call the custom method(s) in your
template file. For the above example, it can be used by calling the `shout`
method in a template file:

**site/_templates/photo.slim**
```slim
div.my-shouting-content
  == shout("HELLO")
```

Some "core" Template Helper plugins available in Photish by default are:

1. [Breadcrumb](https://github.com/henrylawson/photish/blob/master/lib/photish/core_plugin/breadcrumb.rb)
1. [BuildUrl](https://github.com/henrylawson/photish/blob/master/lib/photish/core_plugin/build_url.rb)

#### Deployment Engine Plugins

To create a deployment engine plugin you must:

1. Create a **Ruby Class** in the `Photish::Plugin` module namespace, if
   you are packaging the plugin as a Gem, you can implement your module one
   level deeper in the namespace to allow for the Gem namespace, e.g.
   `Photish::Plugin::MyGemPlugin::MyDeployEngine`
1. Make the plugin available for [loading](#plugin-loading)
1. Implement a `self.is_for?(type)` method and respond true when it receives
   the `Photish::Plugin::Type::Deploy` type
1. Implement a `self.engine_name` method and respond with the name of the
   engine, this needs to match the value the user will pass on the
   [Deploy](#deploy) command
1. Implement a constructor, it should expect two argumnets `initialize(config,
   log)`, a structure representing the config file and an instance of the
   logger
1. Finally the plugin should also implement a `deploy_site` method, this method
   will execute the actual deployment

A simple sample implementation is below:

**site/_plugins/my_custom_deploy.rb**
```ruby
module Photish::Plugin::MyCustomDeploy
  def initialize(config, log)
    @config = config
    @log = log
  end

  def self.is_for?(type)
    Photish::Plugin::Type::Photo == type
  end

  def self.engine_name
    'my_custom_deploy'
  end

  def deploy_site
    @log.debug "Deploying using my plugin"
    FileUtils.cp(@config.output_dir, '/srv/www')
  end
end
```

Some reference implementations of deploy plugins are:

1. [Photish SSH Deploy](https://github.com/henrylawson/photish-plugin-sshdeploy)
1. [Tmp Dir Deploy](https://github.com/henrylawson/photish/blob/master/lib/photish/assets/example/site/_plugins/tmpdir_deploy.rb)

### Plugin Loading

Photish supports the following methods of Plugin loading.

#### Site Folder Loading

By default, Photish will automatically load all files in the `site/_plugins`
directory. This is the most simple way and is recommended if you just want to
write a simple helper specific to your site.

The example site created when running `photish generate --example` uses this
method to load plugins.

#### Explicit Gem Loading

This is recommended method if you want to utilize a plugin created by someone
else in the community - rather than simply copy pasting their code to your
`site/_plugins` directory. It is done by including a Gem in your Photish site's
`Gemfile` and listing the require path of the Gem in the `plugins` [Config File
Option](#config-file-options).

An example of Explicit Gem Loading is provided by the [Photish
Montage](https://github.com/henrylawson/photish-montage) demo that explicitly
loads the
[Photish::Plugin::Sshdeploy](https://github.com/henrylawson/photish-plugin-sshdeploy)
Gem.

To load a Gem as a plugin, first of all add the Gem to your Gemfile:

**Gemfile**

```Gemfile
gem 'photish-plugin-sshdeploy'
```

And in your Photish config, ensure it is listed in your `plugins` [Config File
Option](#config-file-options).

**config.yml**

```YAML
plugins: ['photish/plugin/sshdeploy']
```

Then run `bundle install`.

To confirm that it is installed correctly, when you run the `photish generate`
command, you should see the plugin load:

**log/photish.log or STDOUT**

```
...
... Photish::Plugin::Repository: Found plugin Photish::Plugin::Sshdeploy::Deploy
...
```

Note the 'photish-plugin-sshdeploy' Gem has other install steps documented in
it's [README](https://github.com/henrylawson/photish-plugin-sshdeploy).

## Development

If you would like to contribute to Photish by creating a new feature or fixing
bugs, you are more then welcome!

To develop:

    $ git clone git@github.com:henrylawson/photish.git
    $ cd photish
    $ ./bin/setup     # installs dependencies
    $ Install exiftool as detailed above.
    $ rake            # runs the tests
    $ vim             # open up the project and begin contributing
    $ ./bin/console   # for an interactive prompt

To release:

    $ vim lib/photish/version.rb      # update version
    $ git add -p                      # add in changed files
    $ git commit -m 'Final commit'    # finish up changes
    $ rake                            # ensure all tests pass
    $ rake release                    # release to rubygems

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/henrylawson/photish. This project is intended to be a safe,
welcoming space for collaboration, and contributors are expected to adhere to
the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).

