require "quick_shoulda/version"
require "quick_shoulda/errors"
require "quick_shoulda/path_resolver"
require "quick_shoulda/file_writer"
require "quick_shoulda/generator"
require "quick_shoulda/main"
require "quick_shoulda/config"
require 'fileutils'

module QuickShoulda
	class << self
		include StringHelpers
		include PathResolver
		include FileWriter
		include Generator
		include Main
		include Errors
		
		def process(paths)
			raise PathNotGivenError if paths.empty?
			paths.each { |path| _process(path) }
		end

		def _process(path)			
			unless is_a_constant?(path)
				raise NotAModelPathError unless path =~ /models\//
				raise FileDoesNotExistError unless File.file?(path)
				raise NotRubyFileError unless File.extname(path) == '.rb'
			end

			configure_and_generate(path)
	 	end
	end
end