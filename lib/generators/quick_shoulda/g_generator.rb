module QuickShoulda
  class GGenerator < ::Rails::Generators::Base
  	argument :model_path, :type => :array

  	def generate_shoulda_testcases
  		puts model_path
			QuickShoulda.process(model_path)
  	end
  end	
end