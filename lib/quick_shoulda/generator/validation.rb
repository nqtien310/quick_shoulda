module QuickShoulda
  module Generator
    module Validation
      OptionMethods = {
        :minimum => 'is_at_least',
        :maximum => 'is_at_most',
        :is      => 'is_equal_to'
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
          attributes.map { |attribute| generate(validation_type, attribute, options)}
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
          ".#{OptionMethods[option.to_sym]}(#{value})" if OptionMethods[option]
        end
    end
  end
end
