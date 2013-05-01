require 'spec_helper'

module User
	module Friend

	end
end

describe 'QuickShoulda' do
	describe '#process' do
		let(:spec_folder) { 'spec/models/' }

		describe 'all valid' do
			let(:path) { 'models/user/friend.rb' }
			before { File.should_receive(:file?).with(path).once.and_return(true)	}

			context 'with spec_folder given' do				
				it 'invoke Main::configure_and_generate with given spec_folder' do
					QuickShoulda.should_receive(:configure_and_generate).with(path, spec_folder)
					QuickShoulda.process(path, spec_folder)
				end
			end

			context 'without spec_folder given' do
				it 'invoke Main::configure_and_generate with default spec_folder' do
					QuickShoulda.should_receive(:configure_and_generate).with(path, 'spec/models/')
					QuickShoulda.process(path)
				end
			end			
		end

		context 'path is given' do
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

		context 'constant is given' do
			let(:constant) { "User::Name" }

			it 'should not raise any exception' do
				QuickShoulda.should_receive(:configure_and_generate).with(constant, spec_folder)
				expect { QuickShoulda.process(constant)	}.not_to raise_error
			end
		end
	end	
end