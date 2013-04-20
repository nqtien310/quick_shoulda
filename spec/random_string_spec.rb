require 'spec_helper'

describe "QuickShoulda::RandomString" do
	subject { QuickShoulda::RandomString.new(pattern) }

	describe ".stored_strings"	do
		it 'should return an array of string' do
			QuickShoulda::RandomString.stored_strings.should be_an Array
		end
	end

	describe '.random_digits' do
		it 'should return array of different length digits' do
			random_digits = QuickShoulda::RandomString.random_digits_strings
			random_digits.should be_an Array
			random_digits.each do |random_str|
				(random_str =~ /[0-9]+/).should_not be_nil
			end
		end
	end

	describe '.random_chars' do
		it 'should return array of different length characters' do
			random_chars = QuickShoulda::RandomString.random_chars_strings
			random_chars.should be_an Array
			random_chars.each do |random_str|
				(random_str =~ /[a-zA-Z]+/).should_not be_nil
			end
		end
	end
end