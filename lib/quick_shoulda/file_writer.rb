require 'quick_shoulda/errors'

module QuickShoulda
	module FileWriter		
		DescribeRegex = /^describe\s.+\sdo$/i
		AssociationsBlock = "describe '#Associations' do"
		ValidationsBlock = "describe '#Validations' do"

		Blocks = {
			:association => AssociationsBlock,
			:validation => ValidationsBlock,
		}

		def write_block(block_name, shoulda_lines)			
			shoulda_content = shoulda_content(block_name, shoulda_lines)
			file_content = ''
			File.open(spec_file_path, 'a+') do |file|				
				inserted = false
				while( line = file.gets )
					file_content << line										
					if !inserted && line.strip.gsub(/[\t\n]/,'') =~ DescribeRegex						
						file_content << shoulda_content
						inserted = true
					end
				end				
			end

			File.open(spec_file_path, 'w') { |file | file.write( file_content ) }
		end

		def shoulda_content(block_name, shoulda_lines)
			block = Blocks[block_name.to_sym]
			shoulda_lines.map! { |line| "\t#{line}"}
			shoulda_lines.insert(0, "#{block}")
			shoulda_lines << "end"

			shoulda_lines.map { |line| "\t#{line}"}.join("\n")	
		end

		def init_content(model_constant)
			content = "require 'spec_helper'\n\n"
			content << "describe '#{model_content}' do\n\n"
			content << "end"
		end

		def clear_block(block_name)
			file_content = ""
			File.open(spec_file_path, 'r') do | file |
				
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

			File.open(spec_file_path, 'w') { |file | file.write( file_content ) }
		end		
	end
end