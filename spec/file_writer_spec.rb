require 'spec_helper'
require 'fileutils'

describe 'QuickShoulda::FileWriter' do
	include QuickShoulda::Main
	include QuickShoulda::Generator
	include QuickShoulda::PathResolver
	include QuickShoulda::FileWriter	

	context '#create_file_and_write_init_content' do
		let(:spec_init_content) {
			'spec init content'
		}
		let(:spec_file_path) {
			File.expand_path('../test_written_folder/test_written_file.rb', __FILE__)
		}

		after do
			File.delete spec_file_path
			FileUtils.rm_r File.dirname(spec_file_path)
		end

		it 'should create folders which are in file path' do
			File.should_not be_directory File.dirname(spec_file_path)
			create_file_and_write_init_content
			File.should be_directory File.dirname(spec_file_path)
		end

		it 'should create file' do			
			File.should_not be_file spec_file_path
			create_file_and_write_init_content
			File.should be_file spec_file_path
		end

		it 'should write spec_init_content to file' do
			File.should_not be_file spec_file_path
			create_file_and_write_init_content
			File.read(spec_file_path).should eq spec_init_content
		end
	end

	context '#clear_all_blocks' do
		let(:association_block_header) { "describe '#Associations' do"}
		let(:validation_block_header) { "describe '#Validations' do"}

		it 'should invoke clear_block for validation block' do
			should_receive(:block_describe_header).with(:validation).once.and_return(validation_block_header)
			should_receive(:block_describe_header).with(:association).once.and_return(association_block_header)
			should_receive(:clear_block).with(validation_block_header).once
			should_receive(:clear_block).with(association_block_header).once
			clear_all_blocks
		end
	end

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