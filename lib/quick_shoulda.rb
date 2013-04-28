require "quick_shoulda/version"
require "quick_shoulda/errors"
require "quick_shoulda/path_resolver"
require "quick_shoulda/file_writer"
require "quick_shoulda/generator"

module QuickShoulda
	class Main		
		include PathResolver		
		include FileWriter
		include Generator

		def initialize(path, spec_folder = 'spec/')
			raise FileDoesNotExistError unless File.file?(path)
			raise NotAModelPathError unless path =~ /models\//
			raise NotRubyFileError unless File.extname(path) == '.rb'

			@path = path
			@spec_folder = "#{spec.gsub('/','')}/"
			@model_full_namespace = _model_full_namespace
			@spec_file_path = _spec_file_path
			@validations_block = shoulda_content(:validation, generate_validations(model_full_namespace))
			@associations_block = shoulda_content(:association, generate_associations(model_full_namespace))
		end
	  
		def process
			[:validation, :association].each { |block_name| clear_block block_name }
			write_block(@validations_block + @associations_block)
	 	end
	end
end