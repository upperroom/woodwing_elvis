# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'woodwing_elvis/version'

Gem::Specification.new do |spec|
  spec.name          = "woodwing_elvis"
  spec.version       = Woodwing::Elvis::VERSION
  spec.authors       = ["Dewayne VanHoozer"]
  spec.email         = ["dvanhoozer@gmail.com"]
  spec.summary       = %q{A Ruby implementation of Woodwing's Elvis API}
  spec.description   = %q{Some REST some SOAP some WORK some DON'T}
  spec.homepage      = ""
  spec.license       = "You want it; its yours."

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
