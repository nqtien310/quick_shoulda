require 'spec_helper'

describe 'QuickShoulda::Generator::Validation' do
  include QuickShoulda::StringHelpers
  include QuickShoulda::Generator::Validation

  describe '#generate' do    
    let(:attribute) { :student }

    let(:presence_options) { {} }    
    let(:uniqueness_options) { { scope: [:class, :college]} }    
    let(:format_options) { { with: /abc/} }
    let(:length_options) { { minimum: 1, maximum: 20}}
    let(:inclusion_options) { { within: (1..20), :allow_nil => true, :allow_blank => true} }
    let(:exclusion_options) { { in: ['a', 'b', 'c']} }
    let(:numericality_options) { { only_integer: true, message: 'must be an integer' } }

    let(:random_strings) do
      {
        matched_strings: ['abc'],
        unmatched_strings: ['nqtien310@gmail.com', 'nqtien310@hotdev.com']
      }
    end

    ['presence', 'format', 'uniqueness', 'length', 'inclusion', 'exclusion', 'numericality'].each do | type |      
      let("#{type}_validator_class") { mock("#{type}_validator_class".to_sym, to_s: "ActiveModel::Validations::#{type.upcase}Validator") }
      let("#{type}_validator".to_sym) do        
        mock("#{type}_validator".to_sym, :class => eval("#{type}_validator_class"), 
                                    attributes: [attribute], options: eval("#{type}_options") )
      end
    end

    let(:validators) { [presence_validator, uniqueness_validator, format_validator, length_validator, 
                    inclusion_validator, exclusion_validator, numericality_validator] }
    let(:model) { mock(:model, validators: validators) }

    before { RandomString.should_receive(:generate).with(/abc/).and_return(random_strings) }

    let(:expected) {
      [
        'it { should validate_presence_of(:student) }',        
        'it { should validate_uniqueness_of(:student).scoped_to(:class).scoped_to(:college) }',
        "it { should allow_value('abc').for(:student) }",
        "it { should_not allow_value('nqtien310@gmail.com').for(:student) }",
        "it { should_not allow_value('nqtien310@hotdev.com').for(:student) }",
        "it { should ensure_length_of(:student).is_at_least(1).is_at_most(20) }",
        "it { should ensure_inclusion_of(:student).in_range(1..20).allow_nil(true).allow_blank(true) }",
        'it { should ensure_exclusion_of(:student).in_array(["a", "b", "c"]) }',
        "it { should validate_numericality_of(:student).only_integer.with_message('must be an integer') }"
      ]
    }

    it 'should return exact array of strings' do      
      generate_validations(model).should eq expected
    end
  end

  describe '#generate_for_validator' do
    before { should_receive(:_validation_type).and_return(type) }
    let(:attributes) { [:username, :email] }
    let(:options) { {:minimum => 100, :maximum => 200} }
    let(:validator) { mock(:validator, :attributes => attributes, :options => options) }
    

    context '_validation_type returns nil' do
      let(:type) { nil }

      it 'should return nil' do
        send(:generate_for_validator, validator).should be_nil
      end
    end

    context '_validation_type returns not nil' do
      let(:type) { 'length' }

      context 'attrs_filter returns an empty array' do
        before { should_receive(:attrs_filter).and_return([]) }

        it 'should return nil' do
          send(:generate_for_validator, validator).should be_nil
        end
      end

      context 'attrs_filter does not return an empty array' do
        before { should_receive(:attrs_filter).and_return(attributes) }

        it 'should invoke generate_shouldas valid parameters' do
          should_receive(:generate_shouldas).with(attributes, options)
          send(:generate_for_validator, validator)
        end  

        it 'should assign value to validation_type attr_accessor' do
          validation_type.should be_nil
          send(:generate_for_validator, validator)      
          validation_type.should eq type
        end  
      end
    end
  end

  describe '#attrs_filter' do
    let(:attrs) { [:friendly_id, :username]}

    it 'should remove all attr which can not pass filters' do
      attrs_filter(attrs).should eq [:username]
    end
  end

  describe '#_validation_type' do
    let(:validator_class) { mock(:validator_class, :to_s => validator_class_name) }
    let(:validator) { mock(:validator, :class => validator_class) }
    let(:expected_type) { 'length' }

    context 'valid validator' do
      let(:validator_class_name) { 'ActiveModel::Validations::LengthValidator' }

      it 'should return expected_type' do
        send(:_validation_type, validator).should eq expected_type
      end
    end

    context 'invalid validator' do
      let(:validator_class_name) { 'ActiveModel::Validations::LengthValidatoErrorr' }

      it 'should return nil' do
        send(:_validation_type, validator).should be_nil
      end
    end

    context 'custom validator' do
      let(:validator_class_name) { 'ActiveModel::Validations::EmailValidator' }

      it 'should return nil' do
        send(:_validation_type, validator).should be_nil
      end
    end
  end

  describe '#shoulda_matcher_method' do
    context 'ensure type' do
      ['exclusion', 'inclusion', 'length'].each do |type|
        context "validate #{type}" do
          let(:expected) { "ensure_#{type}_of" }
          it "should return ensure_#{type}_of" do
            should_receive(:validation_type).at_least(1).and_return(type)
            send(:shoulda_matcher_method).should == expected
          end
        end
      end
    end

    context 'validate type' do
      ['presence', 'uniquness'].each do |type|
        context "validate #{type}" do
          let(:expected) { "validate_#{type}_of" }
          it "should return validate_#{type}_of" do
            should_receive(:validation_type).at_least(1).and_return(type)
            send(:shoulda_matcher_method).should == expected
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

      context 'no value methods' do
        ['case_insensitive', 'only_integer'].each do |method|
          it "should invoke #shoulda_method_without_value with #{method}" do
            should_receive(:shoulda_option_method_name).and_return(method)
            should_receive(:shoulda_method_without_value).with(method).once
            send(:shoulda_option_method, nil, value)
          end
        end
      end

      context 'other option method' do
        let(:method) { 'is_at_least' }

        before { should_receive(:shoulda_option_method_name).and_return(method) }
        it 'should invoke #shoulda_normal_option_method' do
          should_receive(:shoulda_normal_option_method).with(method, value)
          send(:shoulda_option_method, nil, value)
        end
      end
    end
  end

  describe '#shoulda_normal_option_method' do
    let(:method) { 'is_at_least'}
    let(:value) { 50 }
    let(:expected) { '.is_at_least(50)' }
    before { should_receive(:value_transform).with(value).and_return('(50)') }

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
      let(:type) { 'format' }
      let(:options) { {:format => /abc/i} }
      let(:expected) { ["it { should allow_value('abc').for(:username) }"] }

      before do
        should_receive(:validation_type).at_least(1).and_return(type) 
        should_receive(:generate_shouldas_for_format_validation).and_return(expected) 
      end

      it 'should return shouldas for format validation' do
        send(:generate_shoulda, attribute, options).should eq expected
      end
    end

    context 'other types' do
      let(:type) { 'length' }
      let(:options) { {:minimum=>1, :maximum=>20} }
      let(:expected) { ['it { should ensure_length_of(:username).is_at_least(1).is_at_most(20) }'] }

      it 'should return 1 complete shoulda test case' do
        should_receive(:validation_type).at_least(1).and_return(type) 
        send(:generate_shoulda, attribute, options).should eq expected
      end
    end
  end

  describe "#shoulda_option_method_name" do
    context 'pass filters' do
      before { should_receive(:pass_filter?).and_return(true) }      

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

    context 'not pass filters' do
      before { should_receive(:pass_filter?).and_return(false)}

      it 'should return nil' do
        send(:shoulda_option_method_name, '', '').should be_nil
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

    before { RandomString.should_receive(:generate).with(options[:with]).and_return(random_strings) }
    after { send(:generate_shouldas_for_format_validation, attr, options) }

    it 'should invoke generate_allow_shouldas for matched_strings and unmatched strings' do
      should_receive(:generate_allow_shouldas).with(:matched_strings, matched_strings, attr)
      should_receive(:generate_allow_shouldas).with(:unmatched_strings, unmatched_strings, attr)
    end
  end

  describe '#pass_filter?' do
    context 'option method does not appear in filter list' do
      let(:option) { 'message' }
      it 'should return true' do
        send(:pass_filter?, option).should be_true
      end
    end

    context 'option method appears in filter list' do
      let(:option) { 'allow_blank' }

      context 'option method matches validation_type' do
        before { should_receive(:validation_type).and_return('inclusion') }
        it 'should return true' do
          send(:pass_filter?, option).should be_true
        end
      end

      context 'option method does not match validation_type' do
        before { should_receive(:validation_type).and_return('presence') }
        it 'should return true' do
          send(:pass_filter?, option).should be_false
        end
      end
    end
  end
end
