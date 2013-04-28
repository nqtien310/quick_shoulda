require 'spec_helper'

module User
	module Friend

	end
end

describe 'QuickShoulda' do
	describe 'Main' do
		describe '#process' do
			describe 'all valid' do

				let(:path) { 'models/user/friend.rb' }		
				let(:validation_lines) {
					[
						'it { should validate_presence_of(:username) }',
						'it { should validate_presence_of(:password) }'
					]
				}

				let(:association_lines) {
					[
						'it { should have_one(:wife) }',
						'it { should have_one(:young_wife) }'
					]
				}

				before do
					File.should_receive(:file?).with(path).once.and_return(true)			
					QuickShoulda.should_receive(:spec_file_exist?).and_return(false)
					QuickShoulda.should_receive(:generate_validations).and_return(validation_lines)	
					QuickShoulda.should_receive(:generate_associations).and_return(association_lines)
					QuickShoulda.process(path)
				end

				after do			
					File.delete(QuickShoulda.spec_file_path)
				end

				it 'should create a new file' do			
					IO.read(QuickShoulda.spec_file_path).should_not be_nil
				end
			end

			describe 'path is nil' do
				it 'should raise QuickShoulda::Errors::PathNotGivenError' do
					expect {
						QuickShoulda.process(nil)
					}.to raise_error(QuickShoulda::Errors::PathNotGivenError)
				end
			end

			describe 'path does not contain "models/"' do
				it 'should raise QuickShoulda::Errors::NotAModelPathError' do
					expect {
						QuickShoulda.process("not/contain/model/s")
					}.to raise_error(QuickShoulda::Errors::NotAModelPathError)
				end
			end

			describe 'file does not exist' do
				it 'should raise QuickShoulda::Errors::FileDoesNotExistError' do
					expect {
						QuickShoulda.process("models/nothere.rb")
					}.to raise_error(QuickShoulda::Errors::FileDoesNotExistError)
				end
			end

			describe 'not a ruby file' do
				it 'should raise QuickShoulda::Errors::NotRubyFileError' do
					expect {
						QuickShoulda.process("models/not_a_ruby_file.txt")
					}.to raise_error(QuickShoulda::Errors::FileDoesNotExistError)
				end
			end
		end		
	end
end