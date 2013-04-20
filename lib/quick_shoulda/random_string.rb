module QuickShoulda
	class RandomString
		class << self
			LowerCaseChars = ('a'..'z').to_a
			UpperCaseChars = ('A'..'Z').to_a
			Digits 				 = (0..9).to_a

			def stored_strings				
				@stored_strings ||= YAML.load File.new(File.join(File.dirname(__FILE__),'..','..','data','stored_strings.yml'))
			end

			def random_digits_strings
				random_strings(Digits)
			end

			def random_chars_strings
				random_strings(LowerCaseChars + UpperCaseChars)
			end

			def random_strings(base)
				(1..30).map { |length| length.times.inject('') { |initial, n| initial + base[rand(10)].to_s } }
			end
		end

		attr_accessor :pattern
		
		def initialize(pattern)
			@pattern = pattern
		end

		def generate

		end
	end
end