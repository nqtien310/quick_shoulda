require "quick_shoulda/version"
require "quick_shoulda/errors"
require "quick_shoulda/path_resolver"
require "quick_shoulda/file_writer"
require "quick_shoulda/generator"
require "quick_shoulda/config"
require 'fileutils'

module QuickShoulda
	class << self
		include PathResolver		
		include FileWriter
		include Generator
		include Config

		def process(path, spec_folder = 'spec/')	
			raise PathNotGivenError unless path
			raise FileDoesNotExistError unless File.file?(path)
			raise NotAModelPathError unless path =~ /models\//
			raise NotRubyFileError unless File.extname(path) == '.rb'
			configure(path, spec_folder)

			FileUtils.mkdir_p(File.dirname(spec_file_path))
			File.open(spec_file_path, 'w') do |file|
				file.write(spec_init_content)
			end unless spec_file_exist?

			[:validation, :association].each { |block_name| clear_block block_name }
			write_block(validations_block + associations_block)
	 	end
	end
end