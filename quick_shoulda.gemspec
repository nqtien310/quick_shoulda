# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quick_shoulda/version'

Gem::Specification.new do |spec|
  spec.name          = "quick_shoulda"
  spec.version       = QuickShoulda::VERSION
  spec.authors       = ["Tien Nguyen"]
  spec.email         = ["nqtien310@gmail.com"]
  spec.description   = %q{TODO: Write a gem description}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
