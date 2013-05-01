require 'random_string'

module QuickShoulda
  module Generator
    module Validation
      AllowsValidators = [
        'presence', 'uniqueness', 'acceptance', 'confirmation', 'exclusion', 'format', 'inclusion', 'length', 'numericality'
      ]

      InclusionOptions = {
        :range      => 'in_range',
        :array      => 'in_array'
      }

      OptionMethods = {
        :minimum          => 'is_at_least',
        :maximum          => 'is_at_most',
        :is               => 'is_equal_to',
        :scope            => 'scoped_to',
        :too_short        => 'with_short_message',
        :too_long         => 'with_long_message',
        :message          => 'with_message',        
        :only_integer     => 'only_integer',
        :case_insensitive => 'case_insensitive',
        :allow_nil        => 'allow_nil',
        :allow_blank      => 'allow_blank',        
        :in               => InclusionOptions,
        :within           => InclusionOptions
      }

      Filters = {
        :allow_blank      => ['inclusion'],
        :allow_nil        => ['inclusion', 'uniqueness'],
        :case_insensitive => ['uniqueness']
      }

      AttrsFilters = ['friendly_id']

      def self.included(base)
        base.class_eval do
          attr_accessor :validation_type
        end
      end
      
      def generate_validations(model)
        model.validators.map { |validator| generate_for_validator(validator) }.compact.flatten
      end

      private

        def generate_for_validator(validator)          
          if @validation_type = _validation_type(validator)            
            return if ( attrs = attrs_filter(validator.attributes) ).empty?
            generate_shouldas(attrs, validator.options)
          end
        end

        def attrs_filter(attrs)
          attrs.select { |attr| !(AttrsFilters.include? attr.to_s) }
        end

        def _validation_type(validator)
          validation_type = validator.class.to_s.scan(/([^:]+)Validator/)
          unless validation_type.empty?
            validator = validation_type.first.first.downcase
            validator if AllowsValidators.include? validator
          end          
        end

        def generate_shouldas(attributes, options)
          attributes.map { |attribute| generate_shoulda(attribute, options) }.flatten
        end

        def generate_shoulda(attribute, options)
          unless validation_type == 'format'
            [ "it { should #{shoulda_matcher_method}(:#{attribute})#{shoulda_option_methods_chain(options)} }" ]
          else
            generate_shouldas_for_format_validation(attribute, options)
          end
        end

        def generate_shouldas_for_format_validation(attribute, options)          
          RandomString.generate(options[:with]).map { |type, strings| generate_allow_shouldas(type, strings, attribute) }.flatten
        end

        def generate_allow_shouldas(type, strings, attribute)          
          should_suffix = type.to_s == 'matched_strings' ? '' : '_not'
          strings.map { |string| "it { should#{should_suffix} allow_value('#{string}').for(:#{attribute}) }" }
        end

        def shoulda_matcher_method
          prefix = ('exclusion|inclusion|length' =~ /#{validation_type}/) ? 'ensure' : 'validate'
          "#{prefix}_#{validation_type}_of"
        end

        #.is_at_least(50).is_at_max(100)
        def shoulda_option_methods_chain(options)
          options.map { |option, value| shoulda_option_method(option, value) }.compact.join
        end
        
        def shoulda_option_method(option, value)          
          method = shoulda_option_method_name(option, value)          
          return unless method

          case method
            when OptionMethods[:scope] 
              shoulda_scope_to_method(value)
            when OptionMethods[:only_integer], OptionMethods[:case_insensitive]
              shoulda_method_without_value(method)
            else 
              shoulda_normal_option_method(method, value)
            end          
        end

        #.is_at_least
        #.is_at_most
        def shoulda_option_method_name(option, value)
          return unless pass_filter?(option)
          option_method = OptionMethods[option.to_sym]
          option_method = option_method[value.class.to_s.downcase.to_sym] if option_method.is_a?(Hash)
          option_method
        end

        def pass_filter?(option)
          !Filters[option.to_sym] || Filters[option.to_sym].include?(validation_type)
        end

        #.is_at_least(50)        
        def shoulda_normal_option_method(method, value)
          ".#{method}#{value_transform(value)}"
        end

        def shoulda_method_without_value(method)
          ".#{method}"
        end

        #.scoped_to(:username).scoped_to(:account)
        def shoulda_scope_to_method(value)
          method = OptionMethods[:scope]
          ([] << value).flatten.map { | v | ".#{method}#{value_transform(v)}" }.join
        end
    end
  end
end