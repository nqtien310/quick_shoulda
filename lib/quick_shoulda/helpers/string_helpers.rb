module QuickShoulda
  module StringHelpers
    def camelize(str)
      return str if str !~ /_/ && str =~ /[A-Z]+.*/
      str.split("_").map{|e| e.capitalize}.join
    end

    def value_transform(value)
 	  	if value.is_a? String
        "('#{value}')"
      elsif value.is_a? Symbol
        "(:#{value})"
      else
        "(#{value})"
      end
    end
  end
end