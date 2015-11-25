# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'photish/version'

Gem::Specification.new do |spec|
  spec.name          = "photish"
  spec.version       = Photish::VERSION
  spec.authors       = ["Henry Lawson"]
  spec.email         = ["henry.lawson@foinq.com"]

  spec.summary       = %q{A static photo site generator}
  spec.description   = %q{Photish is a simple, convention based (but
  configurable) static photo site generator.}
  spec.homepage      = "https://github.com/henrylawson/photish"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9.3'

  spec.add_dependency "thor", "~> 0.1"
  spec.add_dependency "activesupport", "~> 4.2"
  spec.add_dependency "slim", "~> 3.0"
  spec.add_dependency "tilt", "~> 2.0"
  spec.add_dependency "mini_magick", "~> 4.3"
  spec.add_dependency "ruby-filemagic", "~> 0.7"
  spec.add_dependency "anemone", "~> 0.7"
  spec.add_dependency "mini_exiftool", "~> 2.5"
  spec.add_dependency "recursive-open-struct", "~> 0.6"
  spec.add_dependency "colorize", "~> 0.7"
  spec.add_dependency "nokogiri", "~> 1.6"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "retriable"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_development_dependency "rspec-html-matchers"
end
