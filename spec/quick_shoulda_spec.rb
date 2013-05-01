require 'spec_helper'

module User
	module Friend

	end
end

describe 'QuickShoulda' do
	describe '#process' do		
		describe 'paths is empty' do
			it 'should raise QuickShoulda::Errors::PathNotGivenError' do
				expect {
					QuickShoulda.process([])
				}.to raise_error(QuickShoulda::Errors::PathNotGivenError)
			end
		end

		describe 'paths is not empty' do
			let(:paths) { ['User', 'app/models/user.rb'] }
			it 'should invoke _process for each path' do
				paths.each { |path| QuickShoulda.should_receive(:_process).with(path) }
				QuickShoulda.process(paths)
			end
		end
	end

	describe '#_process' do
		describe 'all valid' do
			let(:path) { 'models/user/friend.rb' }
			before { File.should_receive(:file?).with(path).once.and_return(true)	}

			context 'with spec_folder given' do				
				it 'invoke Main::configure_and_generate with given spec_folder' do
					QuickShoulda.should_receive(:configure_and_generate).with(path)
					QuickShoulda._process(path)
				end
			end

			context 'without spec_folder given' do
				it 'invoke Main::configure_and_generate with default spec_folder' do
					QuickShoulda.should_receive(:configure_and_generate).with(path)
					QuickShoulda._process(path)
				end
			end			
		end

		context 'path is given' do
			describe 'path does not contain "models/"' do
				it 'should raise QuickShoulda::Errors::NotAModelPathError' do
					expect {
						QuickShoulda._process("not/contain/model/s")
					}.to raise_error(QuickShoulda::Errors::NotAModelPathError)
				end
			end

			describe 'file does not exist' do
				it 'should raise QuickShoulda::Errors::FileDoesNotExistError' do
					expect {
						QuickShoulda._process("models/nothere.rb")
					}.to raise_error(QuickShoulda::Errors::FileDoesNotExistError)
				end
			end

			describe 'not a ruby file' do
				it 'should raise QuickShoulda::Errors::NotRubyFileError' do
					expect {
						QuickShoulda._process("models/not_a_ruby_file.txt")
					}.to raise_error(QuickShoulda::Errors::FileDoesNotExistError)
				end
			end
		end

		context 'constant is given' do
			let(:constant) { "User::Name" }

			it 'should not raise any exception' do
				QuickShoulda.should_receive(:configure_and_generate).with(constant)
				expect { QuickShoulda._process(constant)	}.not_to raise_error
			end
		end
	end	
end