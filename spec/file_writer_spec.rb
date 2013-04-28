require 'spec_helper'

describe 'QuickShoulda::FileWriter' do
	include QuickShoulda::PathResolver
	include QuickShoulda::FileWriter	

	context '#clear_block' do
		before do
			@test_file_content = IO.read(file_path)
			@spec_file_path = file_path
		end

		after do
			File.open(file_path, 'w') do |file|
				file.write(@test_file_content)
			end
		end

		let(:file_path) { 'spec/fixtures/user_spec.rb' }

		[:association, :validation].each do |block|
			it "should clear the whole #{block} block" do
				clear_block(block)				
				( IO.read(file_path) =~ /#{QuickShoulda::FileWriter::Blocks[block]}/ ).should be_nil
			end
		end
	end

	context '#write_block' do
		before do
			@test_file_content = IO.read(file_path)
			@spec_file_path = file_path
		end

		after do
			File.open(file_path, 'w') do |file|
				file.write(@test_file_content)
			end
		end

		let(:shoulda_lines) {	['it { should be_written }', 'it { should be_written_again }'] }

		let(:file_path) { 'spec/fixtures/write_spec.rb' }

		[:association, :validation].each do |block|
			context "#{block}" do
				let(:expected) do				
					/\n\t#{QuickShoulda::FileWriter::Blocks[block]}\n\t\tit { should be_written }\n\t\tit { should be_written_again }\n\tend/
				end

				it "should write the whole #{block} block" do					
					write_block(block, shoulda_lines)												
					( IO.read(file_path) =~ expected ).should_not be_nil				
				end
			end
		end
	end	
end