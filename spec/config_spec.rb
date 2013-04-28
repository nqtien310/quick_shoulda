require 'spec_helper'
module User
	module Friend

	end
end

describe 'QuickShoulda::Config' do
	include QuickShoulda::Generator
	include QuickShoulda::PathResolver

	describe 'included' do
		['path', 'spec_folder', 'model_full_namespace', 'spec_file_path', 'validations_block', 'associations_block'].each do |var|
			context "Before included" do
				it "should not understand #{var}" do
					expect { eval(var) }.to raise_error(NameError)		
				end
			end

			context "After included" do
				include QuickShoulda::Config

				it "should understand #{var}" do
					eval(var).should be_nil
				end
			end
		end
	end

	describe '#configure' do
		include QuickShoulda::Config
		let(:given_path) { 'models/user/friend.rb' }
		let(:given_spec_folder) { 'spec/' }
		let(:validations) {[]}
		let(:associations) {[]}

		before do			
			should_receive(:generate_validations).and_return(validations)
			should_receive(:generate_associations).and_return(associations)
			configure(given_path, given_spec_folder) 
		end

		context 'path' do
			it 'should store valid value' do
				path.should eq given_path
			end
		end

		context 'spec_folder' do
			it 'should store valid value' do
				spec_folder.should eq given_spec_folder
			end
		end

		context 'model_full_namespace' do
			let(:expected) { ::User::Friend }
			it 'should store valid value' do
				model_full_namespace.should eq expected
			end
		end

		context 'spec_file_path' do
			let(:expected) { 'spec/user/friend_spec.rb' }
			it 'should store valid value' do
				spec_file_path.should eq expected
			end
		end

		context 'validations_block' do
			let(:expected_regex) { /\tdescribe '#Validations' do\n\tend\n\n/ }
			it 'should store valid value' do				
				(validations_block =~ expected_regex).should_not be_nil
			end
		end

		context 'associations_block' do
			let(:expected_regex) { /\tdescribe '#Associations' do\n\tend\n\n/ }
			it 'should store valid value' do
				(associations_block =~ expected_regex).should_not be_nil
			end
		end		
	end
end