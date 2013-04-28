require 'quick_shoulda/generator/validation'
require 'quick_shoulda/generator/association'
require 'quick_shoulda/generator/spec_content'

module QuickShoulda
	module Generator
		include Validation
		include Association
		include SpecContent

		def self.included(base)
			base.class_eval do
				attr_accessor :validations_block, :associations_block
			end
		end
	end
end