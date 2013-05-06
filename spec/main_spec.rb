require 'spec_helper'
module User
	module Friend

	end
end

describe 'QuickShoulda::Main' do
	include QuickShoulda::Generator
	include QuickShoulda::PathResolver
	include QuickShoulda::FileWriter

	describe 'included' do
		['path', 'spec_folder', 'model_full_namespace', 'spec_file_path', 'validations_block', 'associations_block'].each do |var|
			context "Before included" do
				it "should not understand #{var}" do
					expect { eval(var) }.to raise_error(NameError)		
				end
			end

			context "After included" do
				include QuickShoulda::Main

				it "should understand #{var}" do
					eval(var).should be_nil
				end
			end
		end
	end

	describe '#configure_and_generate' do
		include QuickShoulda::Main

		let(:path) { 'path' }

		it 'should invoke configure and generate' do
			should_receive(:configure).with(path)
			should_receive(:generate)
			configure_and_generate(path)
		end
	end

	describe '#configure' do
		include QuickShoulda::Main

		let(:given_path) { 'models/user/friend.rb' }
		let(:validations) {[]}
		let(:associations) {[]}

		context 'path' do
			it 'should store valid value' do
				send(:configure, given_path) 
				path.should eq given_path
			end
		end

		context 'config file given' do
			let(:configs) do
				{ 'spec_folder' => 'aaaaaaaaaaaa' }
			end

			before do				
		  	QuickShoulda::ConfigFileReader.should_receive(:config_file_exist?).and_return(true)
		  	QuickShoulda::ConfigFileReader.should_receive(:read).and_return(configs)
		  	send(:configure, given_path) 
		  end

			context 'spec_folder' do
				it 'should get value from config file' do
					send(:spec_folder).should == configs['spec_folder'] + '/'
				end
			end
		end

		context 'config file is not given' do
			before do
				QuickShoulda::ConfigFileReader.should_receive(:config_file_exist?).and_return(false)
				send(:configure, given_path) 
			end


			context 'spec_folder' do					
				it 'should store valid value' do
					spec_folder.should eq send(:default_spec_folder)
				end
			end

			context 'model_full_namespace' do
				let(:expected) { ::User::Friend }
				it 'should store valid value' do
					model_full_namespace.should eq expected
				end
			end

			context 'spec_file_path' do
				let(:expected) { 'spec/models/user/friend_spec.rb' }
				it 'should store valid value' do
					spec_file_path.should eq expected
				end
			end
		end
		
	end

	describe '#generate' do
		include QuickShoulda::Main

		it 'should invoke generate_shoulda_content and create_and_write_to_file' do
			should_receive(:generate_shoulda_content)
			should_receive(:create_and_write_to_file)			
			send(:generate)
		end
	end

	describe '#generate_shoulda_content' do
		include QuickShoulda::Main

		let(:mfn) { "User::Friend" }
		let(:validations) { [] }

		before do
			should_receive(:model_full_namespace).twice.and_return(mfn)
		end

		it 'should invoke shoulda_content on each generate block' do			
			should_receive(:generate_validations).with(mfn).and_return([])
			should_receive(:shoulda_content).once.with(:validation, [])

			should_receive(:generate_associations).with(mfn).and_return([])
			should_receive(:shoulda_content).once.with(:association, [])
			send(:generate_shoulda_content)
		end
	end

	describe 'create_and_write_to_file' do
		include QuickShoulda::Main

		#should receive clear_all_blocks
		#should receive write block with validations_block and associations_block
		before do
			should_receive(:validations_block).and_return("1")
			should_receive(:associations_block).and_return("2")
			should_receive(:clear_all_blocks)
			should_receive(:write_block).with("12")
		end

		context 'spec_file_path does not exist' do
			before { should_receive(:spec_file_exist?).and_return(false) }
			it 'should invoke create_file_and_write_init_content' do				
				should_receive(:create_file_and_write_init_content)
				create_and_write_to_file
			end
		end

		context 'spec_file_path exists' do
			before { should_receive(:spec_file_exist?).and_return(true) }
			it 'should not invoke create_file_and_write_init_content' do				
				should_not_receive(:create_file_and_write_init_content)
				create_and_write_to_file
			end
		end
	end
end