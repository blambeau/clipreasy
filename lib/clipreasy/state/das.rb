require 'singleton'
module CliPrEasy
  #
  # Provides the Data Access Service of CliPrEasy.
  #
  class DAS
    include Singleton
    
    # Delegates class calls to the singleton, in order to hide the singleton
    # pattern
    class << self
      def method_missing(name, *args)
        self.instance.send(name, *args)
      end
    end
    
    # Starts the service using a database configuration
    def start(config)
      raise IllegalStateError, "DAS has already been started" unless @db.nil?
      @config = config
      @db = Sequel.connect(config)
    rescue PGError => ex
      raise ConfigError, "Something went wrong when trying to connect the database", ex
    end
    
    # Installs the database schema
    def install_schema
      raise IllegalStateError, "DAS has not been previously started" if @db.nil?
      CliPrEasy.config.assert_safe!("Installing database schema cannot be executed in safe mode")
      @db << File.read(File.join(File.dirname(__FILE__), 'clipreasy_schema.pgsql'))
    end
    
    # Stops the service
    def stop
      raise IllegalStateError, "DAS has not been previously started" if @db.nil?
      @db.disconnect
      @db = nil
    end
    
  end # class DAS
end # module CliPrEasy