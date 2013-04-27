require 'quick_shoulda/helpers/string_helpers'

module QuickShoulda
	module PathResolver
		include StringHelpers

		def constant_from_path(path)
			eval model_name_from_path(path)
		end

		# given models/namespace/modelname.rb
		# return Namespace::ModelName
		def model_name_from_path(path)
			model_path = path.split(/\/?models\//)[1].gsub('.rb','')
			model_path.split('/').map { |token| camelize(token) }.join('::')				
		end	
	end
end