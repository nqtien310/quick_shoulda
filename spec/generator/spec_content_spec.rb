require 'spec_helper'

describe 'QuickShoulda::Generator::SpecContent' do
	include QuickShoulda::Generator::SpecContent

	describe '#shoulda_content'	do
		let(:block_name) { :validation }

		context 'with shoulda test cases' do
			let(:shoulda_lines) do
				['it { should validate_presence_of(:username) }',
				 'it { should validate_presence_of(:password) }']
			end

			let(:expected) do
				exp = "\tdescribe '#Validations' do\n"
				exp << "\t\t#{shoulda_lines[0]}\n"
				exp << "\t\t#{shoulda_lines[1]}\n"
				exp << "\tend\n\n"
				exp			
			end

			it 'should return whole shoulda content' do			
				shoulda_content(block_name, shoulda_lines.dup).should eq expected
			end
		end
		
		context 'with shoulda test cases' do
			let(:shoulda_lines) { [] }			

			it 'should return whole shoulda content' do			
				shoulda_content(block_name, shoulda_lines.dup).should eq ''
			end
		end		
	end

	describe '#spec_init_content' do
		before { should_receive(:model_full_namespace).and_return('User::Friend')}

		let(:expected) do
			exp = "require 'spec_helper'\n\n"
			exp << "describe 'User::Friend' do\n\n"
			exp << "end"
		end

		it 'should return valid describe block' do
			spec_init_content.should eq expected
		end
	end

	describe '#block_describe_header' do
		let(:block_name) { 'validation' }
		let(:expected) { "describe '#Validations' do" }

		it 'should invoke to_sym for block_name' do
			block_name.should_receive(:to_sym).once
			block_describe_header(block_name)
		end

		it 'should return the describe header for block' do
			block_describe_header(block_name).should eq expected
		end

	end
end
