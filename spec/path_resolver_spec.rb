require 'spec_helper'

describe 'QuickShoulda::PathResolver' do
	include QuickShoulda::Main
	include QuickShoulda::PathResolver
	before do
		@path = path
		@spec_folder = 'spec/'
	end

	describe '#_model_full_namespace_in_str' do
		context 'constant given' do
			before { should_receive(:is_a_constant?).and_return(true)}
			let(:path) { 'User::Friend' }
			it 'should given constant' do
				_model_full_namespace_in_str.should eq 'User::Friend'
			end
		end

		context 'path given' do
			context 'valid path' do				
				before { should_receive(:is_a_constant?).and_return(false)}

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
	end

	describe '_model_full_namespace' do
		let(:model) { 'QuickShoulda::StringHelpers' }
		before { should_receive(:_model_full_namespace_in_str).and_return(model) }

		it 'should return constant' do			
			_model_full_namespace.should eq ::QuickShoulda::StringHelpers
		end
	end

	context '#_spec_file_path' do
		before { File.stub(:file?).and_return(true) }
		context 'constant given' do
			context 'User' do
				let(:path) { 'User' }
				let(:expected) { 'spec/user_spec.rb' }

				it 'should return valid test file path' do
					_spec_file_path.should eq expected
				end
			end

			context 'User::Friend' do
				let(:path) { 'User::Friend' }
				let(:expected) { 'spec/user/friend_spec.rb' }

				it 'should return valid test file path' do
					_spec_file_path.should eq expected
				end
			end

			context '::User::Friend' do
				let(:path) { '::User::Friend' }
				let(:expected) { 'spec/user/friend_spec.rb' }

				it 'should return valid test file path' do
					_spec_file_path.should eq expected
				end
			end
		end

		context 'path given' do
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

	context '#is_a_constant?' do
		['::User::Friend', 'Friend', 'User::Friend', 'User::Friend::Best'].each do |constant|
			it "should return true for #{constant}" do
				is_a_constant?(constant).should be_true
			end
		end

		['user.rb', 'User.rb', 'user'].each do |constant|
			it "should return false for #{constant}" do
				is_a_constant?(constant).should be_false
			end
		end
	end
end