  require 'quick_shoulda/random_string'

module QuickShoulda
  module Generator
    module Validation
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

      def generate(model)
        model.validators.map { |validator| generate_for_validator(validator) }.compact.flatten
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
          attributes.map { |attribute| generate_shoulda(validation_type, attribute, options) }.flatten
        end

        def generate_shoulda(validation_type, attribute, options)
          unless validation_type == 'format'
            [ "it { should #{shoulda_matcher_method(validation_type)}(:#{attribute})#{shoulda_option_methods_chain(options)} }" ]
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
          option_method = OptionMethods[option.to_sym]
          option_method = option_method[value.class.to_s.downcase.to_sym] if option_method.is_a?(Hash)
          option_method
        end

        #.is_at_least(50)        
        def shoulda_normal_option_method(method, value)
          ".#{method}#{option_value(value)}"
        end

        def shoulda_method_without_value(method)
          ".#{method}"
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