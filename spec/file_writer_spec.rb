require 'spec_helper'

describe 'QuickShoulda::FileWriter' do
	include QuickShoulda::Config
	include QuickShoulda::Generator
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

		[:association, :validation].each do |block_name|
			it "should clear the whole #{block_name} block" do
				block = block_describe_header(block_name)
				( IO.read(file_path) =~ /#{block}\n.+\n.+\n\tend/ ).should_not be_nil				
				clear_block(block)
				( IO.read(file_path) =~ /#{block}\n.+\n.+\n\tend/ ).should be_nil
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
					/\n\t#{block_describe_header(block)}\n\t\tit { should be_written }\n\t\tit { should be_written_again }\n\tend/
				end

				it "should write the whole #{block} block" do
					( IO.read(file_path) =~ expected ).should be_nil
					write_block(shoulda_content(block, shoulda_lines))
					( IO.read(file_path) =~ expected ).should_not be_nil				
				end
			end
		end
	end	
end