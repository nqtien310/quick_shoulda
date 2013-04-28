require 'quick_shoulda/errors'

module QuickShoulda
	module FileWriter		
		DescribeRegex = /^describe\s.+\sdo$/i		

		def write_block(shoulda_content)	
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

		def clear_block(block)
			file_content = ""
			File.open(spec_file_path, 'r') do | file |
				
				delete_mode = false				

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