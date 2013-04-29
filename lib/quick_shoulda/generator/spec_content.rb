module QuickShoulda
	module Generator
		module SpecContent
			def block_describe_header(block_name)
				case block_name.to_sym
					when :association 
						"describe '#Associations' do"
					when :validation 
						"describe '#Validations' do"
				end
			end
			
			def shoulda_content(block_name, shoulda_lines)
				return "" unless shoulda_lines.size > 0
				
				block = block_describe_header(block_name)
				shoulda_lines.map! { |line| "\t#{line}"}
				shoulda_lines.insert(0, "#{block}")
				shoulda_lines << "end\n"

				shoulda_lines.map { |line| "\t#{line}"}.join("\n")	
			end

			def spec_init_content
				content = "require 'spec_helper'\n\n"
				content << "describe '#{model_full_namespace}' do\n"
				content << "end"				
			end
		end
	end
end