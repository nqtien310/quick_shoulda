require 'quick_shoulda/random_string'

module QuickShoulda
  module Generator
    module Validation
      InclusionOptions = {
        :range      => 'in_range',
        :array      => 'in_array'
      }

      OptionMethods = {
        :minimum    => 'is_at_least',
        :maximum    => 'is_at_most',
        :is         => 'is_equal_to',
        :scope      => 'scope_to',
        :too_short  => 'with_short_message',
        :too_long   => 'with_long_message',
        :message    => 'with_message',        
        :in         => InclusionOptions,
        :within     => InclusionOptions
      }

      def generate(model)
        model.validators.each { |validator| generate_for_validator(validator) }
      end

      private
        def generate_for_validator(validator)
          if validation_type = validation_type(validator)
            generate_shouldas(validation_type, validator.attributes, validator.options)
          end
        end

        def validation_type(validator)
          validation_type = validator.class.to_s.scan(/([^:]+)Validator/)
          validation_type.first.first.downcase unless validation_type.empty?
        end

        def generate_shouldas(validation_type, attributes, options)
          attributes.map { |attribute| generate_test_case(validation_type, attribute, options)}
        end

        def generate_shoulda(validation_type, attribute, options)
          "it { should #{shoulda_matcher_method(validation_type)}(:#{attribute})#{shoulda_option_methods_chain(options)} }"
        end

        def shoulda_matcher_method(validation_type)
          prefix = ('exclusion|inclusion|length' =~ /#{validation_type}/) ? 'ensure' : 'validate'
          "#{prefix}_#{validation_type}_of"
        end

        #.is_at_least(50).is_at_max(100)
        def shoulda_option_methods_chain(options)
          options.map { |option, value| shoulda_option_method(option, value) }.compact.join
        end
        
        def shoulda_option_method(option, value)
          method = shoulda_option_method_name(option, value)          
          method == OptionMethods[:scope] ? shoulda_scope_to_method(value) : shoulda_normal_option_method(method, value) if method
        end

        #.is_at_least
        #.is_at_most
        def shoulda_option_method_name(option, value)
          option_method = OptionMethods[option.to_sym]
          option_method = option_method[value.class.to_s.downcase.to_sym] if option_method.is_a?(Hash)
          option_method
        end

        #.is_at_least(50)        
        def shoulda_normal_option_method(method, value)          
          ".#{method}#{option_value(value)}"
        end

        #.scoped_to(:username).scoped_to(:account)
        def shoulda_scope_to_method(value)
          method = OptionMethods[:scope]
          ([] << value).flatten.map { | v | ".#{method}(:#{v})" }.join
        end

        #(50)
        #('value')
        def option_value(value)
          value.is_a?(String) ? "('#{value}')" : "(#{value})"
        end
    end
  end
end