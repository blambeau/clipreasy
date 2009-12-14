require 'singleton'
module CliPrEasy
  #
  # Provides the Data Access Service of CliPrEasy.
  #
  class DAS
    include Singleton
    
    # Starts the service using a database configuration
    def start(config)
      raise IllegalStateError, "DAS has already been started" unless @db.nil?
      @config = config
      @db = Sequel.connect(config)
    rescue PGError => ex
      raise ConfigError, "Something went wrong when trying to connect the database", ex
    end
    
    # Stops the service
    def stop
      raise IllegalStateError, "DAS has not been previously started" if @db.nil?
      @db.disconnect
    end
    
  end # class DAS
end # module CliPrEasy