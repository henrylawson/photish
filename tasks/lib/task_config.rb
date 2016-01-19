module TaskConfig
  EXPECTED_RUBY_VERSION = '2.2.2'
  TRAVELING_RUBY_VERSION = "20150715-#{EXPECTED_RUBY_VERSION}"

  PACKAGING_DIR = 'packaging'
  BINARY_DIR = ENV['BINARY_DIR'] || 'pkg'
  TEMP_DIR = ENV['TEMP_DIR'] || 'tmp/packaging'
  RELEASES_DIR = "#{TEMP_DIR}/releases"
  SCRATCH_DIR = "#{TEMP_DIR}/scratch"
end
