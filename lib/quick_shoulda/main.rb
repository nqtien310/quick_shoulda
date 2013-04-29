module QuickShoulda
	module Main
		def self.included(base)
			base.class_eval do
				attr_accessor :path, :spec_folder, :model_full_namespace, :spec_file_path, :validations_block, :associations_block
			end
		end

		def configure_and_generate(path, spec_folder)
			configure(path, spec_folder)
			generate
		end

		private

			def configure(path, spec_folder)
				@path = path
				@spec_folder = spec_folder[-1] != '/' ? "#{spec_folder}/" : spec_folder
				@model_full_namespace = _model_full_namespace
				@spec_file_path = _spec_file_path
			end

			def generate
				generate_shoulda_content
				create_and_write_to_file
			end

			def generate_shoulda_content
				@validations_block = shoulda_content(:validation, generate_validations(model_full_namespace))
				@associations_block = shoulda_content(:association, generate_associations(model_full_namespace))				
			end

			def create_and_write_to_file
				create_file_and_write_init_content unless spec_file_exist?
				clear_all_blocks
				write_block(validations_block + associations_block)
			end	
	end
end