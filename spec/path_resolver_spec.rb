require 'spec_helper'

describe 'QuickShoulda::PathResolver' do
	include QuickShoulda::PathResolver

	describe 'model_name_from_path' do
		context 'valid path' do
			context 'without namespace' do
				let(:path) { '/models/user_account'}

				context 'with .rb' do
					it 'should return valid model name' do					
						model_name_from_path(path).should eq 'UserAccount'
					end
				end

				context 'without .rb' do
					before { path = "#{path}.rb" }
					it 'should return valid model name' do
						model_name_from_path(path).should eq 'UserAccount'
					end
				end
			end

			context 'with namespace' do
				let(:path) { 'models/user/friend.rb' }
				it 'should return valid model name with namespace' do
					model_name_from_path(path).should eq 'User::Friend'
				end
			end
		end
	end

	describe 'constant_from_path' do
		let(:model) { 'QuickShoulda::StringHelpers' }
		before { should_receive(:model_name_from_path).and_return(model) }

		it 'should return constant' do			
			constant_from_path('').should eq QuickShoulda::StringHelpers
		end
	end
end