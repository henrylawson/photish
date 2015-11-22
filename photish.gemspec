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
  spec.description   = %q{Using a collection of photos grouped by folder, photish will generate a the website content using templates that you provide.}
  spec.homepage      = "https://github.com/henrylawson/photish"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "thor"
  spec.add_dependency "activesupport"
  spec.add_dependency "slim"
  spec.add_dependency "tilt"
  spec.add_dependency "mini_magick"
  spec.add_dependency "ruby-filemagic"
  spec.add_dependency "anemone"
  spec.add_dependency "mini_exiftool"
  spec.add_dependency "recursive-open-struct"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "retriable"
end
