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
  
  # Starts a process execution
  def self.start_process(id)
    CliPrEasy::State::ProcessExecutionBackend.start_process(id)
  end
  
  # Let the engine know that an activity has been ended
  def self.activity_ended(id)
    CliPrEasy::State::ProcessExecutionBackend.activity_ended(id)
  end
  
  # Installs the database schema on a given Sequel database
  def self.install_db_schema(db)
    db << File.read(File.join(File.dirname(__FILE__), 'clipreasy', 'model', 'clipreasy_schema.pgsql'))
  end
  
end
require 'clipreasy/errors'
require 'clipreasy/config'
require 'clipreasy/model/das'
require 'clipreasy/model/transaction'
require 'clipreasy/model/tuple'
require 'clipreasy/model/relation'
require 'clipreasy/engine'
require 'clipreasy/model/process_persistence'
require 'clipreasy/model/process_execution_backend'
