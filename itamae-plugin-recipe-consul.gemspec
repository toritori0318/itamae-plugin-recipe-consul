# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'itamae/plugin/recipe/consul/version'

Gem::Specification.new do |spec|
  spec.name          = "itamae-plugin-recipe-consul"
  spec.version       = Itamae::Plugin::Recipe::Consul::VERSION
  spec.authors       = ["toritori0318"]
  spec.email         = ["toritori0318@gmail.com"]
  spec.summary       = %q{Itamae recipe plugin for consul.}
  spec.description   = %q{Itamae recipe plugin for consul.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
