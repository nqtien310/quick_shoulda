require 'spec_helper'

describe 'QuickShoulda::StringHelpers' do
	include QuickShoulda::StringHelpers

	describe '#value_transform' do
		context 'string value' do
			let(:value) { 'value' }
			let(:expected) { "('value')"}

			it 'should return value wrapped inside single quotes' do
				value_transform(value).should eq expected
			end
		end

		context 'symbol value' do
			let(:value) { :value }
			let(:expected) { "(:value)"}

			it 'should return symbol value' do
				value_transform(value).should eq expected
			end
		end

		context 'other types of value' do
			let(:value) { %w{a b c} }
			let(:expected) { '(["a", "b", "c"])'}

			it 'should return symbol value' do
				value_transform(value).should eq expected
			end
		end
	end
end