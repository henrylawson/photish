# Photish Todo

## In Progress

1. Work out why coverage has dropped so dramatically
1. Change `init` to have `--example` and normal for barebones, add `Gemfile` to
   `init`

## Backlog

1. Plugin as a gem to deploy to github pages, netlify, amazon s3
1. Custom template rendering outside of `_templates` folder using `page.{type}`
1. Proper asset pipeline for CSS
1. A sitemap helper plugin for use in custom templates for example
   `sitemap.xml`
1. Share on RubyWebToolkit, StaticGen, etc
1. RDoc documentation for classes, perhaps use the badge too
1. More intelligent regeneration based on changes, delete files in output not
   created by generator
1. Provide generic way to override config from arguments to allow for hostname
   override on deploy etc.
1. Add timestamp to file log appender and any other details to make it more
   useable
1. Video transcoding and template rendering
1. Review gem dependencies - remove what is not needed, update what is needed
1. Thread pooling and parrallel forking for transcodes
1. Ignore page generation if template does not exist
