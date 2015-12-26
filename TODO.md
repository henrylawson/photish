# Photish Todo

## In Progress

1. Url and base are broken during template/image creation
1. Solve problem for explicit urls mentioned in templates (that need host/base)
1. Need to have parameters to change on deploy
1. During Host command nullify url options to work on host
1. Deploy README content
1. Extract the SSH deploy to gem

## Backlog

1. Empty folders exist in output dir after orig removed and regeneration has happened
1. Worker can die when large folders moved mid generation
1. Changing convert items does not trigger regeneration but changing name does
1. Templates with exif data, super slow
1. Plugin as a gem to deploy to github pages, netlify, amazon s3
1. Custom template rendering outside of `_templates` folder using `page.{type}`
1. Proper asset pipeline for CSS
1. A sitemap helper plugin for use in custom templates for example
   `sitemap.xml`
1. Share on RubyWebToolkit, StaticGen, etc
1. RDoc documentation for classes, perhaps use the badge too
1. Provide generic way to override config from arguments to allow for host name
   override on deploy etc.
1. Video transcoding and template rendering
1. Demo sites with better design
