#
# Main module of Clinical Process Made Easy
#
module CliPrEasy
  
  # Current version
  VERSION = "0.0.1".freeze
  
  # Returns the configuration
  def config
    raise IllegalStateError, "CliPrEasy has not been started (no configuration loaded)"\
      unless @config
    @config
  end
  
  # Starts the engine, loading the configuration from a whoami file.
  # If no whoami file is provided the default one is loaded from project's root.
  def self.start(whoami_file=nil)
    whoami_file = File.join(File.dirname(__FILE__), '..', 'whoami') if whoami_file.nil?
    @config = CliPrEasy::Config.load(whoami_file)
  end
  
  # Stops the application
  def self.stop
  end
  
end
require 'clipreasy/errors'
require 'clipreasy/config'
require 'clipreasy/engine'