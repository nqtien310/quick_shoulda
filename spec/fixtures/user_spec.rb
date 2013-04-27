describe 'User', :test => true do
	describe '#Associations' do
		it { should have_many(:attr1) }
		it { should have_many(:attr2) }
	end

	describe '#Validations' do
		it { should validate_presence_of(:user) }
		it { should validate_presence_of(:password) }
	end
end