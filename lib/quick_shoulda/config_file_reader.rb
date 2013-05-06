module QuickShoulda
	module ConfigFileReader
		class << self			
			def read
				YAML.load(File.open(config_file_name))
			end

			def config_file_exist?
				File.file?(config_file_name)
			end

			private 
				def config_file_name
					'./.qshoulda.yml'
				end
		end		
	end
end