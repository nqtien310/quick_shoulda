# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quick_shoulda/version'

Gem::Specification.new do |spec|
  spec.name          = "quick_shoulda"
  spec.version       = QuickShoulda::VERSION
  spec.authors       = ["Tien Nguyen"]
  spec.email         = ["nqtien310@gmail.com"]
  spec.description   = %q{Read model file to extract the validations/associations
                          and then utilize Rails generator to write correspondent shoulda test cases to your correspondent spec file }
  spec.summary       = %q{read through your model file and generate Shoulda test cases }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "random_string"
  spec.add_development_dependency "debugger", "~> 1.3"
  spec.add_development_dependency "rspec"
end
