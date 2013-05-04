require "bundler/gem_tasks"
require "quick_shoulda/version.rb"
require 'rspec/core/rake_task'

task :install_mah_gem do
  exec %{ 
  	gem uninstall quick_shoulda; 
  	gem build quick_shoulda.gemspec;
  	gem install quick_shoulda-#{QuickShoulda::VERSION}.gem; }
end

task :default => :spec
RSpec::Core::RakeTask.new