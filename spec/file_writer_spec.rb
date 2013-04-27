require 'spec_helper'

describe 'QuickShoulda::FileWriter' do
	subject { QuickShoulda::FileWriter.new(file_path) }

	context 'test_file_path' do
		before { File.stub(:file?).and_return(true) }
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

	context '#clear_block' do
		before { @test_file_content = IO.read(file_path) }

		after do
			File.open(file_path, 'w') do |file|
				file.write(@test_file_content)
			end
		end

		let(:file_path) { 'spec/fixtures/user_spec.rb' }

		[:association, :validation].each do |block|
			it "should clear the whole #{block} block" do
				subject.should_receive(:test_file_path).at_least(1).and_return(file_path)
				subject.clear_block(block)				
				( IO.read(file_path) =~ /#{QuickShoulda::FileWriter::Blocks[block]}/ ).should be_nil
			end
		end
	end

	context '#write_block' do
		before { @test_file_content = IO.read(file_path) }

		after do
			File.open(file_path, 'w') do |file|
				file.write(@test_file_content)
			end
		end

		let(:shoulda_lines) {
			['it { should be_written }', 'it { should be_written_again }']
		}

		let(:file_path) { 'spec/fixtures/write_spec.rb' }

		[:association, :validation].each do |block|
			context "#{block}" do
				let(:expected) do				
					/\n\t#{QuickShoulda::FileWriter::Blocks[block]}\n\t\tit { should be_written }\n\t\tit { should be_written_again }\n\tend/
				end

				it "should write the whole #{block} block" do
					subject.should_receive(:test_file_path).at_least(1).and_return(file_path)
					subject.write_block(block, shoulda_lines)												
					( IO.read(file_path) =~ expected ).should_not be_nil				
				end
			end
		end
	end	
end