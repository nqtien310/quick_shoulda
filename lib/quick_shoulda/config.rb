module QuickShoulda
	module Config
		def self.included(base)
			base.class_eval do
				attr_accessor :path, :spec_folder, :model_full_namespace, :spec_file_path, :validations_block, :associations_block
			end
		end

		def configure(path, spec_folder)
			@path = path
			@spec_folder = "#{spec_folder.gsub('/','')}/"
			@model_full_namespace = _model_full_namespace
			@spec_file_path = _spec_file_path
			@validations_block = shoulda_content(:validation, generate_validations(model_full_namespace))
			@associations_block = shoulda_content(:association, generate_associations(model_full_namespace))
		end
	end
end