require 'quick_shoulda/random_string/data'

module QuickShoulda
	module RandomString
		class << self
			Size = 3
			LowerCaseChars = ('a'..'z').to_a
			UpperCaseChars = ('A'..'Z').to_a
			Digits 				 = (0..9).to_a

			def sample_strings
				stored_strings + random_digits_strings + random_chars_strings
			end

			def stored_strings		
				@stored_strings ||= Data::StoredStrings.values.flatten
			end

			def random_digits_strings
				random_strings(Digits)
			end

			def random_chars_strings
				random_strings(LowerCaseChars + UpperCaseChars)
			end

			def random_strings(base)
				(1..50).map { |length| length.times.inject('') { |initial, n| initial + base[rand(10)].to_s } }
			end

			def generate(pattern)
				matched_strings = []
				unmatched_strings = []
				RandomString.sample_strings.each do |sample_string|
					break if matched_strings.size == Size && unmatched_strings.size == Size

					if sample_string =~ pattern
						matched_strings << sample_string if matched_strings.size < Size
					else
						unmatched_strings << sample_string if unmatched_strings.size < Size
					end
				end

				{
					matched_strings:   matched_strings,
					unmatched_strings: unmatched_strings
				}
			end

			alias_method :gen, :generate
		end
	end
end