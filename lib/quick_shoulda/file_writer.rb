require 'quick_shoulda/errors'

module QuickShoulda
	class FileWriter
		AssociationsBlock = "describe '#Associations' do"
		ValidationsBlock = "describe '#Validations' do"

		Blocks = {
			:association => AssociationsBlock,
			:validation => ValidationsBlock,
		}

		def initialize(file_path)
			@file_path = file_path					
		end

		def clear_block(block_name)			
			raise Errors::FileDoesNotExistError unless File.file? test_file_path

			File.open(test_file_path, 'w+') do | file |
				file_content = ""				
				delete_mode = false
				block = Blocks[block_name.to_sym]

				while( line = file.gets )				
					filtered_line = line.gsub(/[\n\t]/,'')

					if filtered_line == block || delete_mode
						delete_mode = true if filtered_line == block
						delete_mode = false if filtered_line == 'end'
						next
					end

					file_content << line
				end
				file.write( file_content ) 
			end			
		end

		def test_file_path
			@test_file_path ||= _test_file_path
		end

		def _test_file_path
			tokens = @file_path.split(/\/?models\//)
			raise Errors::InvalidPathError if tokens.size <= 1
			model_path = tokens[1]
			file_name = "#{File.basename(model_path, ".rb")}_spec.rb"
			dir_name = File.dirname(model_path) == '.' ? 'spec/' : "spec/#{File.dirname(model_path)}/"		
			"#{dir_name}#{file_name}"
		end
	end
end