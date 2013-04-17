$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'quick_shoulda'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}
#
# RSpec.configure do |config|
#   config.include FixtureContent
#   end
