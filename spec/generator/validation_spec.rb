require 'spec_helper'

describe 'QuickShoulda::Generator::Validation' do
  include QuickShoulda::Generator::Validation

  describe '#generate' do    
    let(:attribute) { :student }

    let(:presence_options) { {} }    
    let(:uniqueness_options) { { scope: [:class, :college]} }    
    let(:format_options) { { with: /abc/} }
    let(:length_options) { { minimum: 1, maximum: 20}}
    let(:inclusion_options) { { within: (1..20)} }
    let(:exclusion_options) { { in: ['a', 'b', 'c']} }

    let(:random_strings) do
      {
        matched_strings: ['abc'],
        unmatched_strings: ['nqtien310@gmail.com', 'nqtien310@hotdev.com']
      }
    end

    ['presence', 'format', 'uniqueness', 'length', 'inclusion', 'exclusion'].each do | type |      
      let("#{type}_validator_class") { mock("#{type}_validator_class".to_sym, to_s: "ActiveModel::Validations::#{type.upcase}Validator") }
      let("#{type}_validator".to_sym) do        
        mock("#{type}_validator".to_sym, :class => eval("#{type}_validator_class"), 
                                    attributes: [attribute], options: eval("#{type}_options") )
      end
    end

    let(:validators) { [presence_validator, uniqueness_validator, format_validator, length_validator, 
                    inclusion_validator, exclusion_validator] }
    let(:model) { mock(:model, validators: validators) }

    before { QuickShoulda::RandomString.should_receive(:generate).with(/abc/).and_return(random_strings) }

    let(:expected) {
      [
        'it { should validate_presence_of(:student) }',        
        'it { should validate_uniqueness_of(:student).scoped_to(:class).scoped_to(:college) }',
        "it { should allow_value('abc').for(:student) }",
        "it { should_not allow_value('nqtien310@gmail.com').for(:student) }",
        "it { should_not allow_value('nqtien310@hotdev.com').for(:student) }",
        "it { should ensure_length_of(:student).is_at_least(1).is_at_most(20) }",
        "it { should ensure_inclusion_of(:student).in_range(1..20) }",
        'it { should ensure_exclusion_of(:student).in_array(["a", "b", "c"]) }'
      ]
    }

    it 'should return exact array of strings' do      
      generate(model).should eq expected
    end
  end

  describe '#generate_for_validator' do
    before { should_receive(:validation_type).and_return(expected_type) }

    let(:attributes) { [:username, :email] }
    let(:options) { {:minimum => 100, :maximum => 200} }
    let(:validator) { mock(:validator, :attributes => attributes, :options => options) }
    let(:expected_type) { 'length' }

    it 'should invoke generate_shouldas valid parameters' do
      should_receive(:generate_shouldas).with(expected_type, attributes, options)
      send(:generate_for_validator, validator)
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
      before { should_receive(:shoulda_option_method_name).and_return(nil) }
      it 'should return nil' do
        send(:shoulda_option_method, nil, nil).should be_nil
      end
    end

    context 'can look up for option method' do
      let(:value) { 'value' }
      context 'scope_to option method' do
        before { should_receive(:shoulda_option_method_name).and_return('scoped_to') }

        it 'should invoke #scope_to' do
          should_receive(:shoulda_scope_to_method).with(value).once
          send(:shoulda_option_method, nil, value)
        end
      end

      context 'other option method' do
        let(:method) { 'is_at_least' }
        before { should_receive(:shoulda_option_method_name).and_return(method) }
        it 'should invoke #normal_method' do
          should_receive(:shoulda_normal_option_method).with(method, value)
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
      send(:shoulda_normal_option_method, method, value).should eq expected
    end
  end

  describe '#shoulda_option_methods_chain' do
    context 'no options given' do
      it 'should return ""' do
        send(:shoulda_option_methods_chain,{}).should be_empty
      end
    end

    context 'options given' do
      context 'matched options' do
        context 'contain invalid option' do
          let(:options) { {:minimum=>1, :maximum11=>20} }
          let(:expected) { ".is_at_least(1)" }
          it 'should return shoulda option methods corresponded with given options exclude the invalid option' do
            send(:shoulda_option_methods_chain, options).should eq expected
          end
        end

        context 'do not contain invalid option' do
          let(:options) { {:minimum=>1, :maximum=>20} }
          let(:expected) { ".is_at_least(1).is_at_most(20)" }
          it 'should return shoulda option methods corresponded with given options' do
            send(:shoulda_option_methods_chain, options).should eq expected
          end
        end
      end
    end
  end

  describe '#generate_shoulda' do
    let(:attribute) { :username }

    context 'format type' do
      let(:validation_type) { 'format' }
      let(:options) { {:format => /abc/i} }
      let(:expected) { ["it { should allow_value('abc').for(:username) }"] }

      before { should_receive(:generate_shouldas_for_format_validation).and_return(expected) }

      it 'should return shouldas for format validation' do
        send(:generate_shoulda, validation_type, attribute, options).should eq expected
      end
    end

    context 'other types' do
      let(:validation_type) { 'length' }
      let(:options) { {:minimum=>1, :maximum=>20} }
      let(:expected) { ['it { should ensure_length_of(:username).is_at_least(1).is_at_most(20) }'] }

      it 'should return 1 complete shoulda test case' do
        send(:generate_shoulda, validation_type, attribute, options).should eq expected
      end
    end
  end

  describe "#shoulda_option_method_name" do
    context 'rails validate option is mapped to a shoulda method' do
      let(:option) { :minimum }
      let(:expected) { 'is_at_least' }
      let(:value) { '' }

      it 'should return the mapped shoulda method' do
        send(:shoulda_option_method_name, option, value).should eq expected
      end
    end

    context 'rails validate option is mapped to a hash' do
      context 'value type mapped to a shoulda method' do
        let(:option) { :in }
        let(:value) { 1..2 }
        let(:expected) { 'in_range' }

        it 'should return the mapped shoulda method' do
          send(:shoulda_option_method_name, option, value).should eq expected
        end
      end

      context 'value type is not mapped to a shoulda method' do
        let(:option) { :in }
        let(:value) { 'abcdef' }        

        it 'should return nil' do
          send(:shoulda_option_method_name, option, value).should be_nil
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

  describe '#shoulda_scope_to_method' do
    context 'single attr' do
      let(:value) { :username }
      let(:expected) { ".scoped_to(:username)" }
      it 'should encapsulate attr inside scope_to()' do
        send(:shoulda_scope_to_method, value).should eq expected
      end
    end

    context 'array attr' do
      let(:value) { [:account, :date]}
      let(:expected) { ".scoped_to(:account).scoped_to(:date)"}

      it 'should encapsulate each attr inside scope_to()' do
        send(:shoulda_scope_to_method, value).should eq expected
      end
    end
  end

  describe '#generate_allow_shouldas' do
    context 'allow' do
      let(:type) { 'matched_strings' }
      let(:strings) do
        ['nqtien310@gmail.com', 'nqtien310@hotdev.com']
      end
      let(:attr) { :email }
      let(:expected) do
        ["it { should allow_value('nqtien310@gmail.com').for(:#{attr}) }",
         "it { should allow_value('nqtien310@hotdev.com').for(:#{attr}) }",   
        ]
      end

      it 'should return full shoulda allow test cases' do
        send(:generate_allow_shouldas, type, strings, attr).should eq expected
      end
    end
  end

  describe '#generate_shouldas_for_format_validation' do
    let(:attr) { 'email' }
    let(:matched_strings) { ['123','456'] }
    let(:unmatched_strings) { ['abc'] }
    let(:options) { {with: /123|456/ } }

    let(:random_strings) {
      {
        matched_strings: matched_strings,
        unmatched_strings: unmatched_strings
      }
    }

    before { QuickShoulda::RandomString.should_receive(:generate).with(options[:with]).and_return(random_strings) }
    after { send(:generate_shouldas_for_format_validation, attr, options) }

    it 'should invoke generate_allow_shouldas for matched_strings and unmatched strings' do
      should_receive(:generate_allow_shouldas).with(:matched_strings, matched_strings, attr)
      should_receive(:generate_allow_shouldas).with(:unmatched_strings, unmatched_strings, attr)
    end
  end
end
