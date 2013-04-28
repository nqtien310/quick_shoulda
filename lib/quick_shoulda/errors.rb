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
		
		class NotRubyFileError < StandardError
			def initialize(msg = 'Given file must have .rb extension')
				super(msg)
			end
		end

		class PathNotGivenError < StandardError
			def initialize(msg = 'path to model file must be given')
				super(msg)
			end
		end		
	end
end