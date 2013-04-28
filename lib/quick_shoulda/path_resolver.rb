require 'quick_shoulda/helpers/string_helpers'

module QuickShoulda
	module PathResolver
		include StringHelpers

		def self.included(base)
			base.class_eval do
				attr_accessor :path, :model_full_namespace, :spec_file_path, :spec_folder
			end
		end
		
		private
			def _model_full_namespace
				eval _model_full_namespace_in_str
			end

			def _spec_file_path
				model_path = path.split(/\/?models\//)[1]			
				file_name = "#{File.basename(model_path, ".rb")}_spec.rb"
				dir_name = File.dirname(model_path) == '.' ? spec_folder : "#{spec_folder}#{File.dirname(model_path)}/"		
				"#{dir_name}#{file_name}"
			end

			# given models/namespace/modelname.rb
			# return Namespace::ModelName
			def _model_full_namespace_in_str
				model_path = path.split(/\/?models\//)[1].gsub('.rb','')
				model_path.split('/').map { |token| camelize(token) }.join('::')				
			end	
		end
	end