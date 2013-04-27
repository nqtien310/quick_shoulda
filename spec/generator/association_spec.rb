require 'spec_helper'

describe 'QuickShoulda::Generator::Association' do
  include QuickShoulda::Generator::Association

  describe '#generate' do    
  
  end

  describe 'generate_for_association' do
    let(:association) do
      mock(:association, :macro => :has_many, 
                         :name => :friendly_users, 
                         :options => options )
    end
    let(:options) { 
      {
        :dependent  => :destroy,
        :class_name => 'User',
        :order      => 'users.email DESC'
      }
    }

    let(:expected) do
      "it { should have_many(:friendly_users).dependent('destroy').class_name('User').order('users.email DESC') }"
    end

    it 'should return valid shoulda test case' do
      send(:generate_for_association, association).should eq expected
    end
  end 

  describe 'shoulda_option_method_with_value' do    
    context 'option exists in predefined OptionMethods' do
      let(:option) { 'dependent' }
      let(:value) { 'destroy' }
      let(:expected) { ".dependent('destroy')" }

      it 'should return valid shoulda option method with value' do
        send(:shoulda_option_method_with_value, option, value).should eq expected
      end
    end

    context 'option does not exist in predefined OptionMethods' do
      let(:option) { 'dependent1' }

      it 'should return nil' do
        send(:shoulda_option_method_with_value, option, '').should be_nil
      end
    end
  end
end