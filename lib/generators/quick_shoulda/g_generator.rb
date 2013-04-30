module QuickShoulda
  class GGenerator < ::Rails::Generators::Base
  	argument :model_path, :type => :string

  	def generate_shoulda_testcases
			QuickShoulda.process(model_path)
  	end
  end	
end