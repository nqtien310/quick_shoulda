require 'quick_shoulda/errors'

module QuickShoulda
	class FileWriter
		AssociationsBlock = '#Associations'
		ValidatorsBlock = '#Validations'

		def initialize(file_path)
			@file_path = file_path			
		end

		def clear_block(block)

		end

		def test_file_path
			tokens = @file_path.split(/\/?models\//)
			raise Errors::InvalidPathError if tokens.size <= 1
			model_path = tokens[1]
			file_name = "#{File.basename(model_path, ".rb")}_spec.rb"
			dir_name = File.dirname(model_path) == '.' ? 'spec/' : "spec/#{File.dirname(model_path)}/"		
			"#{dir_name}#{file_name}"
		end
	end
end