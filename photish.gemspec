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

  spec.add_development_dependency "anemone", "~> 0.7"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.5"
  spec.add_development_dependency "aruba", "~> 0.12"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "cucumber", "~> 2.3"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "retriable", "~> 2.1"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 0.4"
  spec.add_development_dependency "rspec-html-matchers", "~> 0.7"
  spec.add_development_dependency "metric_fu", "~> 4.12"
  spec.add_development_dependency "photish-plugin-sshdeploy", "~> 0.1"
  spec.add_development_dependency "awesome_print", "~> 1.6"
  spec.add_development_dependency "travis", "~> 1.8"
  spec.add_development_dependency "fpm", "~> 1.4"
end
