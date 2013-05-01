module QuickShoulda
  class GGenerator < ::Rails::Generators::Base
  	argument :model_path, :type => :array

  	def generate_shoulda_testcases  		
			QuickShoulda.process(model_path)
  	end
  end	
end