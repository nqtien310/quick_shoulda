require 'quick_shoulda/generator/validation'
require 'quick_shoulda/generator/association'
require 'quick_shoulda/generator/spec_content'

module QuickShoulda
	module Generator
		include Validation
		include Association
		include SpecContent
	end
end