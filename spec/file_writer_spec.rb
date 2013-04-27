require 'spec_helper'

describe 'QuickShoulda::FileWriter' do
	subject { QuickShoulda::FileWriter.new(file_path) }

	context 'test_file_path' do
		context 'valid file path' do
			context 'without namespace' do
				let(:file_path) { 'models/user.rb' }
				let(:expected) { 'spec/user_spec.rb' }

				it 'should return valid test file path' do
					subject.test_file_path.should eq expected
				end
			end	

			context 'with namespace' do
				let(:file_path) { 'models/friendly/user.rb' }
				let(:expected) { 'spec/friendly/user_spec.rb'}

				it 'should return valid test file path' do
					subject.test_file_path.should eq expected
				end
			end

			context 'with slash at beginning of file path' do
				let(:file_path) { '/models/friendly/user.rb' }
				let(:expected) { 'spec/friendly/user_spec.rb'}

				it 'should return valid test file path' do
					subject.test_file_path.should eq expected
				end
			end

			context 'without .rb' do
				let(:file_path) { 'models/friendly/user' }
				let(:expected) { 'spec/friendly/user_spec.rb'}

				it 'should return valid test file path' do
					subject.test_file_path.should eq expected
				end
			end
		end

		context 'invalid file path' do
			let(:file_path) { 'models' }

			it 'should raise Errors::InvalidPathError error' do
				expect { subject.test_file_path }.to raise_error QuickShoulda::Errors::InvalidPathError
			end
		end
	end
end