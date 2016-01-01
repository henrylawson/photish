# Photish Todo

## In Progress

1. Custom template rendering outside of `_templates` folder using `page.{type}`
1. Move plugins from core_plugins into correct namespace, move library code elsewhere
1. Make metadata and exif core plugins
1. Simplify config code, class names, level of config
1. Clean up api of manifest db file, workers should be initialised
1. Consider bang operations on the manifest file class
1. Rename it existing manifest db file as a repo, and create an actual file object to encapsulate write
1. Use pry as the console tool, with awesome print
1. Delete bread crumbable
1. Rename and rethink render classes
1. Load all plugins method in base

## Backlog

1. Video transcoding and template rendering for videos
1. Templates with exif data, super slow
1. Proper asset pipeline for CSS
1. A sitemap helper plugin for use in custom templates for example
   `sitemap.xml`
1. Add unit tests to classes relying on feature tests
1. Improve metric scores from `rake stats`
1. Improve the `--example` template of Photish
