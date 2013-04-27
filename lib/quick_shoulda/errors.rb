module QuickShoulda
	module Errors
		class InvalidPathError < StandardError
			def initialize(msg = 'Invalid path given')
				super(msg)
			end
		end
	end
end