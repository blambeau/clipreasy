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
      def method_missing(name, *args, &block)
        self.instance.send(name, *args, &block)
      end
    end
    
    # Starts the service using a database configuration. An optional database
    # instance may be given. In this case it will be used in place of a fresh
    # new one.
    def start(config, db = nil)
      raise IllegalStateError, "DAS has already been started" unless @db.nil?
      @config = config
      @db = (db || Sequel.connect(config))
    rescue PGError => ex
      raise ConfigError, "Something went wrong when trying to connect the database", ex
    end
    
    # Stops the service
    def stop
      raise IllegalStateError, "DAS has not been previously started" if @db.nil?
      @db.disconnect
      @db = nil
    end
    
    # Installs the database schema
    def install_schema
      raise IllegalStateError, "DAS has not been previously started" if @db.nil?
      CliPrEasy.config.assert_safe!("Installing database schema cannot be executed in safe mode")
      @db << File.read(File.join(File.dirname(__FILE__), 'clipreasy_schema.pgsql'))
    end
    
    # Executes the given block in a transaction
    def transaction
      raise IllegalStateError, "DAS has not been previously started" if @db.nil?
      raise IllegalStateError, "No block given when using DAS.transaction", caller unless block_given?
      @db.transaction do |conn|
        yield CliPrEasy::State::Transaction.new(@db, conn)
      end
    end
    
    # Returns a Sequel dataset instance
    def dataset(name)
      raise IllegalStateError, "DAS has not been previously started" if @db.nil?
      @db[name]
    end
    
    # Returns a relation with a given name
    def relation(name)
      raise IllegalStateError, "DAS has not been previously started" if @db.nil?
      CliPrEasy::State::Relation.new(@db[name])
    end
    
  end # class DAS
end # module CliPrEasy