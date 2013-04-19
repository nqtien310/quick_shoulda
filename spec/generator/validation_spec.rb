require 'spec_helper'

describe 'QuickShoulda::Generator::Validation' do
  include QuickShoulda::Generator::Validation

  describe 'generate_test_cases_for_validator' do
    before { should_receive(:validation_type).and_return(expected_type) }

    let(:attributes) { [:username, :email] }
    let(:options) { {:minimum => 100, :maximum => 200} }
    let(:validator) { mock(:validator, :attributes => attributes, :options => options) }
    let(:expected_type) { 'length' }

    it 'should invoke generate_test_cases with valid parameters' do
      should_receive(:generate_test_cases).with(expected_type, attributes, options)
      send(:generate_test_cases_for_validator, validator)
    end
  end

  describe '#validation_type' do
    let(:validator_class) { mock(:validator_class, :to_s => validator_class_name) }
    let(:validator) { mock(:validator, :class => validator_class) }
    let(:expected_type) { 'length' }

    context 'valid validator' do
      let(:validator_class_name) { 'ActiveModel::Validations::LengthValidator' }

      it 'should return expected_type' do
        send(:validation_type, validator).should eq expected_type
      end
    end

    context 'invalid validator' do
      let(:validator_class_name) { 'ActiveModel::Validations::LengthValidatoErrorr' }

      it 'should return nil' do
        send(:validation_type, validator).should be_nil
      end
    end
  end

  describe '#shoulda_matcher_method' do
    context 'ensure type' do
      ['exclusion', 'inclusion', 'length'].each do |type|
        context "validate #{type}" do
          let(:expected) { "ensure_#{type}_of" }
          it "should return ensure_#{type}_of" do
            send(:shoulda_matcher_method, type).should == expected
          end
        end
      end
    end

    context 'validate type' do
      ['presence', 'uniquness'].each do |type|
        context "validate #{type}" do
          let(:expected) { "validate_#{type}_of" }
          it "should return validate_#{type}_of" do
            send(:shoulda_matcher_method, type).should == expected
          end
        end
      end
    end
  end

  describe '#shoulda_option_method' do
    context 'cannot look up for option method' do
      before { should_receive(:option_method).and_return(nil) }
      it 'should return nil' do
        send(:shoulda_option_method, nil, nil).should be_nil
      end
    end

    context 'can look up for option method' do
      let(:value) { 'value' }
      context 'scope_to option method' do
        before { should_receive(:option_method).and_return('scope_to') }
        it 'should invoke #scope_to' do
          should_receive(:scope_to).with(value).once
          send(:shoulda_option_method, nil, value)
        end
      end

      context 'other option method' do
        let(:method) { 'is_at_least' }
        before { should_receive(:option_method).and_return(method) }
        it 'should invoke #normal_method' do
          should_receive(:normal_method).with(method, value)
          send(:shoulda_option_method, nil, value)
        end
      end
    end
  end

  describe '#normal_method' do
    let(:method) { 'is_at_least'}
    let(:value) { 50 }
    let(:expected) { '.is_at_least(50)' }
    before { should_receive(:option_value).with(value).and_return('(50)') }

    it 'should return a text contain both method and value' do
      send(:normal_method, method, value).should eq expected
    end
  end

  describe '#shoulda_options' do
    context 'no options given' do
      it 'should return ""' do
        send(:shoulda_options,{}).should be_empty
      end
    end

    context 'options given' do
      context 'matched options' do
        context 'contain invalid option' do
          let(:options) { {:minimum=>1, :maximum11=>20} }
          let(:expected) { ".is_at_least(1)" }
          it 'should return shoulda option methods corresponded with given options exclude the invalid option' do
            send(:shoulda_options, options).should eq expected
          end
        end

        context 'do not contain invalid option' do
          let(:options) { {:minimum=>1, :maximum=>20} }
          let(:expected) { ".is_at_least(1).is_at_most(20)" }
          it 'should return shoulda option methods corresponded with given options' do
            send(:shoulda_options, options).should eq expected
          end
        end
      end
    end
  end

  describe '#generate' do
    let(:validation_type) { 'length' }
    let(:attribute) { :username }
    let(:options) { {:minimum=>1, :maximum=>20} }
    let(:expected) { 'it { should ensure_length_of(:username).is_at_least(1).is_at_most(20) }' }

    it 'should return 1 complete shoulda test case' do
      send(:generate_test_case, validation_type, attribute, options).should eq expected
    end
  end

  describe "#option_method" do
    context 'rails validate option is mapped to a shoulda method' do
      let(:option) { :minimum }
      let(:expected) { 'is_at_least' }
      let(:value) { '' }

      it 'should return the mapped shoulda method' do
        send(:option_method, option, value).should eq expected
      end
    end

    context 'rails validate option is mapped to a hash' do
      context 'value type mapped to a shoulda method' do
        let(:option) { :in }
        let(:value) { 1..2 }
        let(:expected) { 'in_range' }

        it 'should return the mapped shoulda method' do
          send(:option_method, option, value).should eq expected
        end
      end

      context 'value type is not mapped to a shoulda method' do
        let(:option) { :in }
        let(:value) { 'abcdef' }        

        it 'should return nil' do
          send(:option_method, option, value).should be_nil
        end
      end
    end
  end

  describe '#option_value' do
    context 'value is String' do
      let(:value) { 'value' }
      let(:expected) { "('#{value}')" }
      it 'should return value encapsulated inside single quote' do
        send(:option_value, value).should eq expected
      end
    end

    context 'value is not String' do
      let(:value) { 100 }
      let(:expected) { "(#{value})" }
      it 'should return value encapsulated inside single quote' do
        send(:option_value, value).should eq expected
      end
    end
  end

  describe '#scope_to' do
    context 'single attr' do
      let(:value) { :username }
      let(:expected) { ".scope_to(:username)" }
      it 'should encapsulate attr inside scope_to()' do
        send(:scope_to, value).should eq expected
      end
    end

    context 'array attr' do
      let(:value) { [:account, :date]}
      let(:expected) { ".scope_to(:account).scope_to(:date)"}

      it 'should encapsulate each attr inside scope_to()' do
        send(:scope_to, value).should eq expected
      end
    end
  end
end
