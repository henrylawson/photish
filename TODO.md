# Photish Todo

## In Progress

1. Deploy README content
1. Extract the SSH deploy to gem

## Backlog

1. Dry up the SimpleCov config that is everywhere
1. Mime-types gem required 2.0 and above, lost 1.9.x, does this matter?
1. Need to have parameters to change on deploy
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
