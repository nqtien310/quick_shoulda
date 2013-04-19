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

      def generate_test_cases_for_model(model)
        model.validators.each { |validator| generate_test_cases_for_validator(validator) }
      end

      private
        def generate_test_cases_for_validator(validator)
          if validation_type = validation_type(validator)
            generate_test_cases(validation_type, validator.attributes, validator.options)
          end
        end

        def validation_type(validator)
          validation_type = validator.class.to_s.scan(/([^:]+)Validator/)
          validation_type.first.first.downcase unless validation_type.empty?
        end

        def generate_test_cases(validation_type, attributes, options)
          attributes.map { |attribute| generate_test_case(validation_type, attribute, options)}
        end

        def generate_test_case(validation_type, attribute, options)
          "it { should #{shoulda_matcher_method(validation_type)}(:#{attribute})#{shoulda_options(options)} }"
        end

        def shoulda_matcher_method(validation_type)
          prefix = ('exclusion|inclusion|length' =~ /#{validation_type}/) ? 'ensure' : 'validate'
          "#{prefix}_#{validation_type}_of"
        end

        def shoulda_options(options)
          options.map { |option, value| shoulda_option_method(option, value) }.compact.join
        end

        def shoulda_option_method(option, value)
          method = option_method(option, value)          
          method == OptionMethods[:scope] ? scope_to(value) : normal_method(method, value) if method
        end

        def option_method(option, value)
          option_method = OptionMethods[option.to_sym]
          option_method = option_method[value.class.to_s.downcase.to_sym] if option_method.is_a?(Hash)
          option_method
        end

        def normal_method(method, value)          
          ".#{method}#{option_value(value)}"
        end

        def scope_to(value)
          method = OptionMethods[:scope]
          ([] << value).flatten.map { | v | ".#{method}(:#{v})" }.join
        end

        def option_value(value)
          value.is_a?(String) ? "('#{value}')" : "(#{value})"
        end
    end
  end
end