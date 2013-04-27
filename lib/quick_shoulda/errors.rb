module QuickShoulda
	module Errors
		class InvalidPathError < StandardError
			def initialize(msg = 'Invalid path given')
				super(msg)
			end
		end

		class FileDoesNotExistError < StandardError
			def initialize(msg = 'This file does not exist')
				super(msg)
			end
		end

		class NotAModelPathError < StandardError
			def initialize(msg = 'file must located inside models directory')
				super(msg)
			end
		end
	end
end