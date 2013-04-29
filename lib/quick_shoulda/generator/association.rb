module QuickShoulda
  module Generator
    module Association
      MappedMacros = {
        :has_one                  => 'have_one',
        :has_many                 => 'have_many',
        :belongs_to               => 'belong_to',
        :has_and_belongs_to_many  => 'have_and_belong_to_many'
      }

      OptionMethods = {
        :dependent   => 'dependent',
        :through     => 'through',
        :class_name  => 'class_name',
        :touch       => 'touch',
        :validate    => 'validate',
        :order       => 'order',
        :foreign_key => 'with_foreign_key'
      }

      SingleQuoteMethods = ['order', 'class_name']

      def generate_associations(model)
        model.reflect_on_all_associations.map { |association| generate_for_association(association) }.compact.flatten
      end

      private

        def generate_for_association(association)
          shoulda_method_name = MappedMacros[association.macro.to_sym]
          "it { should #{shoulda_method_name}(:#{association.name})#{shoulda_assciation_option_methods_chain(association.options)} }"
        end

        def shoulda_assciation_option_methods_chain(options)
          options.map do |option, value|
            shoulda_option_method_with_value(option, value)
          end.compact.join
        end

        def shoulda_option_method_with_value(option, value)    
          method_name = OptionMethods[option.to_sym]          
          ".#{method_name}#{value_transform(value)}" if method_name
        end
    end
  end
end