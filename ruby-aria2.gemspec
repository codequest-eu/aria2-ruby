# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby/aria2/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby-aria2"
  spec.version       = Ruby::Aria2::VERSION
  spec.authors       = ["Jiahao Li"]
  spec.email         = ["isundaylee.reg@gmail.com"]
  spec.description   = %q{TODO: A gem to interact with Aria2 in Ruby. }
  spec.summary       = %q{TODO: A gem to interact with Aria2 in Ruby. }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
