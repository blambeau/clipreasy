require 'rubygems'
require 'sequel'
#
# Main module of Clinical Process Made Easy
#
module CliPrEasy
  
  # Current version
  VERSION = "0.0.1".freeze
  
  # Returns the configuration
  def self.config
    raise IllegalStateError, "CliPrEasy has not been started (no configuration loaded)"\
      unless @config
    @config
  end
  
  # Starts the engine, loading the configuration from a whoami file.
  # If no whoami file is provided the default one is loaded from project's root.
  def self.start(whoami_file=nil)
    whoami_file = File.join(File.dirname(__FILE__), '..', 'whoami') if whoami_file.nil?
    @config = CliPrEasy::Config.load(whoami_file)
    CliPrEasy::DAS.start(@config.database_info)
  end
  
  # Stops the application
  def self.stop
    CliPrEasy::DAS.stop
  end
  
end
require 'clipreasy/errors'
require 'clipreasy/config'
require 'clipreasy/state/das'
require 'clipreasy/state/tuple'
require 'clipreasy/state/relation'
require 'clipreasy/engine'
require 'clipreasy/state/process_persistence'
require 'clipreasy/state/process_execution_backend'
