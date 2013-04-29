module QuickShoulda
	module Generators
	  class GenerateGenerator < ::Rails::Generators::Base
	  	argument :model_path, :type => :string

	  	def generate_shoulda_testcases
				puts model_path
				puts '-------------------------------------'
				QuickShoulda.process(model_path)
	  	end
	  end
	end
end