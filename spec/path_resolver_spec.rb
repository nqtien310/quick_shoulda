require 'spec_helper'

describe 'QuickShoulda::PathResolver' do
	include QuickShoulda::Config
	include QuickShoulda::PathResolver
	before do
		@path = path
		@spec_folder = 'spec/'
	end

	describe '_model_full_namespace_in_str' do
		context 'valid path' do
			context 'without namespace' do
				let(:path) { '/models/user_account'}

				context 'with .rb' do
					it 'should return valid model name' do					
						_model_full_namespace_in_str.should eq 'UserAccount'
					end
				end

				context 'without .rb' do
					before { path = "#{path}.rb" }
					it 'should return valid model name' do
						_model_full_namespace_in_str.should eq 'UserAccount'
					end
				end
			end

			context 'with namespace' do
				let(:path) { 'models/user/friend.rb' }
				it 'should return valid model name with namespace' do
					_model_full_namespace_in_str.should eq 'User::Friend'
				end
			end
		end
	end

	describe '_model_full_namespace' do
		let(:model) { 'QuickShoulda::StringHelpers' }
		before { should_receive(:_model_full_namespace_in_str).and_return(model) }

		it 'should return constant' do			
			_model_full_namespace.should eq QuickShoulda::StringHelpers
		end
	end

	context '_spec_file_path' do
		before { File.stub(:file?).and_return(true) }
		context 'valid file path' do
			context 'without namespace' do
				let(:path) { 'models/user.rb' }
				let(:expected) { 'spec/user_spec.rb' }

				it 'should return valid test file path' do
					_spec_file_path.should eq expected
				end
			end	

			context 'with namespace' do
				let(:path) { 'models/friendly/user.rb' }
				let(:expected) { 'spec/friendly/user_spec.rb'}

				it 'should return valid test file path' do
					_spec_file_path.should eq expected
				end
			end

			context 'with slash at beginning of file path' do
				let(:path) { '/models/friendly/user.rb' }
				let(:expected) { 'spec/friendly/user_spec.rb'}

				it 'should return valid test file path' do
					_spec_file_path.should eq expected
				end
			end

			context 'without .rb' do
				let(:path) { 'models/friendly/user' }
				let(:expected) { 'spec/friendly/user_spec.rb'}

				it 'should return valid test file path' do
					_spec_file_path.should eq expected
				end
			end
		end
	end
end