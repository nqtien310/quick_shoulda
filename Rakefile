require "bundler/gem_tasks"

task :install_mah_gem do
  exec %{ 
  	gem uninstall quick_shoulda; 
  	gem build quick_shoulda.gemspec;
  	gem install quick_shoulda-0.0.2.gem; }
end