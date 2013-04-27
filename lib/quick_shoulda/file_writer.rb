require 'quick_shoulda/errors'

module QuickShoulda
	class FileWriter
		DescribeRegex = /^describe\s.+\sdo$/i
		AssociationsBlock = "describe '#Associations' do"
		ValidationsBlock = "describe '#Validations' do"

		Blocks = {
			:association => AssociationsBlock,
			:validation => ValidationsBlock,
		}

		def initialize(file_path)
			@file_path = file_path					
		end

		def write_block(block_name, shoulda_lines)
			raise Errors::FileDoesNotExistError unless File.file? test_file_path
			
			shoulda_content = shoulda_content(block_name, shoulda_lines)
			file_content = ''
			
			File.open(test_file_path, 'a+') do |file|				
				inserted = false
				while( line = file.gets )
					file_content << line										
					if !inserted && line.strip.gsub(/[\t\n]/,'') =~ DescribeRegex						
						file_content << shoulda_content
						inserted = true
					end
				end				
			end

			File.open(test_file_path, 'w') { |file | file.write( file_content ) }
		end

		def shoulda_content(block_name, shoulda_lines)
			block = Blocks[block_name.to_sym]
			shoulda_lines.map! { |line| "\t#{line}"}
			shoulda_lines.insert(0, "#{block}")
			shoulda_lines << "end"

			shoulda_lines.map { |line| "\t#{line}"}.join("\n")	
		end

		def clear_block(block_name)
			raise Errors::FileDoesNotExistError unless File.file? test_file_path

			file_content = ""
			File.open(test_file_path, 'r') do | file |
				
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
			end

			File.open(test_file_path, 'w') { |file | file.write( file_content ) }
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