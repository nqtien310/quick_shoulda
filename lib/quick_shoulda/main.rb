require 'quick_shoulda/config_file_reader'

module QuickShoulda
	module Main
		def self.included(base)
			base.class_eval do
				attr_accessor :path, :spec_folder, :model_full_namespace, :spec_file_path, :validations_block, :associations_block
			end
		end

		def configure_and_generate(path)
			configure(path)
			generate
		end

		private

			def configure(path)
				@path = path
				@spec_folder = default_spec_folder

				if ConfigFileReader.config_file_exist?
					configs = ConfigFileReader.read
					@spec_folder = configs['spec_folder'].dup if configs['spec_folder']
					@spec_folder << "/" if @spec_folder[-1].to_s != '/' 
				end

				@model_full_namespace = _model_full_namespace
				@spec_file_path = _spec_file_path
			end

			def default_spec_folder
				'spec/models/'
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