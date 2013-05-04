require 'spec_helper'

describe 'QuickShoulda::Generator::Association' do
  include QuickShoulda::StringHelpers
  include QuickShoulda::Generator::Association

  describe '#generate_for_association' do
    let(:association) do
      mock(:association, :macro => :belongs_to, 
                         :name => :friendly_user, 
                         :options => options )
    end
    let(:options) { 
      {
        :dependent   => :destroy,
        :class_name  => 'User',
        :order       => 'users.email DESC',
        :foreign_key => 'friendly_user_id'
      }
    }

    let(:expected) do
      "it { should belong_to(:friendly_user).dependent(:destroy).class_name('User').order('users.email DESC').with_foreign_key('friendly_user_id') }"
    end

    before do
      should_receive(:shoulda_assciation_option_methods_chain).with(options).
      and_return(".dependent(:destroy).class_name('User').order('users.email DESC').with_foreign_key('friendly_user_id')")
    end

    it 'should return valid shoulda test case' do
      send(:generate_for_association, association).should eq expected
    end
  end 

  describe '#shoulda_option_method_with_value' do    
    context 'option exists in predefined OptionMethods' do
      let(:option) { 'dependent' }
      let(:value) { 'destroy' }
      let(:expected) { ".dependent('destroy')" }

      it 'should return valid shoulda option method with value as symbol' do
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