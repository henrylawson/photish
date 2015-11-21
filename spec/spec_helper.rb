$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'photish'
require 'photish/log'
require 'photish/config/settings'
require 'photish/config/location'
require 'photish/config/file_config'
require 'photish/gallery/album'
require 'photish/gallery/photo'
require 'photish/gallery/collection'
require 'photish/gallery/image'

def fixture_file(path)
  File.join(File.dirname(__FILE__), 'fixtures', path)
end
