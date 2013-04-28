require 'spec_helper'

module User
	module Friend

	end
end

describe 'QuickShoulda' do
	describe 'Main' do
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
		end
	end
end