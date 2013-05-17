# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'devkit/version'

Gem::Specification.new do |spec|
  spec.name          = "devkit"
  spec.version       = Devkit::VERSION
  spec.authors       = ["The Egghead Creative"]
  spec.email         = ["developers@eggheadcreative.com"]
  spec.description   = %q{Developer kit for switching between git and ssh identities}
  spec.summary       = %q{Developer kit for easily managing multiple user identities across machines}
  spec.homepage      = "http://eggheadcreative.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_runtime_dependency "highline"
  spec.add_runtime_dependency "colorize"
end
