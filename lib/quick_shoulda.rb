require "quick_shoulda/version"
require "quick_shoulda/errors"
require "quick_shoulda/path_resolver"
require "quick_shoulda/file_writer"
require "quick_shoulda/generator"
require "quick_shoulda/main"
require 'fileutils'

module QuickShoulda
	class << self
		include PathResolver
		include FileWriter
		include Generator
		include Main
		include Errors
		
		def process(path, spec_folder = 'spec/models/')
			raise PathNotGivenError unless path
			raise NotAModelPathError unless path =~ /models\//
			raise FileDoesNotExistError unless File.file?(path)
			raise NotRubyFileError unless File.extname(path) == '.rb'
			configure_and_generate(path, spec_folder)
	 	end
	end
end