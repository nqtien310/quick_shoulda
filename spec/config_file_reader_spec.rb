require 'spec_helper'

describe 'QuickShoulda::ConfigFileReader' do
	subject { QuickShoulda::ConfigFileReader }
	describe '#config_file_exist?' do
		context 'with config file' do
			before { subject.stub(:config_file_name).and_return('./spec/spec_helper.rb') }

			it 'should return true' do
				subject.config_file_exist?.should be_true
			end
		end

		context 'without config file' do
			it 'should return false' do
				subject.config_file_exist?.should be_false
			end
		end
	end

	describe '#read' do
		before { subject.stub(:config_file_name).and_return('./.travis.yml') }
		
		it 'should return a hash of configurations' do
			subject.read.should be_a Hash			
		end

		it 'has string keys' do
			subject.read.keys.each do |key|
				key.should be_a String
			end
		end
	end
end