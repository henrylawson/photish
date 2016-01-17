# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'photish/version'

Gem::Specification.new do |spec|
  spec.name          = Photish::NAME
  spec.version       = Photish::VERSION
  spec.authors       = [Photish::AUTHOR_NAME]
  spec.email         = [Photish::AUTHOR_EMAIL]

  spec.summary       = Photish::SUMMARY
  spec.description   = Photish::DESCRIPTION
  spec.homepage      = Photish::HOMEPAGE
  spec.license       = Photish::LICENSE

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/[^\.]}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0'

  spec.add_dependency "thor", "~> 0.1"
  spec.add_dependency "activesupport", "~> 4.2"
  spec.add_dependency "slim", "~> 3.0"
  spec.add_dependency "tilt", "~> 2.0"
  spec.add_dependency "mini_magick", "~> 4.3"
  spec.add_dependency "mini_exiftool", "~> 2.5"
  spec.add_dependency "recursive-open-struct", "~> 1.0"
  spec.add_dependency "listen", "~> 3.0"
  spec.add_dependency "colorize", "~> 0.7.7"

  spec.add_development_dependency "anemone"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "aruba"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "retriable"
  spec.add_development_dependency "codeclimate-test-reporter"
  spec.add_development_dependency "rspec-html-matchers"
  spec.add_development_dependency "metric_fu"
  spec.add_development_dependency "photish-plugin-sshdeploy"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "travis"
  spec.add_development_dependency "fpm"
end
