require "quick_shoulda/version"
require "quick_shoulda/errors"
require "quick_shoulda/path_resolver"
require "quick_shoulda/file_writer"
require "quick_shoulda/generator"


module QuickShoulda
	class Main
		include PathResolver	
		include Generator
		include FileWriter

		def initialize(path, spec_folder = self.spec_folder)
			raise FileDoesNotExistError unless File.file?(path)
			raise NotAModelPathError unless path =~ /models\//
			raise NotRubyFileError unless File.extname(path) == '.rb'			

			@path = path
			@spec_folder = "#{spec.gsub('/','')}/"
			@model_full_namespace = _model_full_namespace
			@spec_file_path = _spec_file_path
		end
	  
		def process			
			create_block(:validation, generate_validations(model_full_namespace))
			create_block(:association, generate_associations(model_full_namespace)) 			
	 	end
	end
end