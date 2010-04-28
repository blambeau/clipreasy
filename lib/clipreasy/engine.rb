module CLiPrEasy
  class Engine
    
    # The underlying rubyrel database
    attr_reader :database
    alias :db :database
    
    # Creates an engine instance, using a sequel database
    # handler for the persistence layer.
    def initialize(handler)
      @database = ::Rubyrel::connect(handler)
      @processes = {}
    end
    
    # Finds a process from its identifier
    def process(process_id)
      @processes[process_id] ||= ::CliPrEasy::Persistence::Rubyrel::load_process(database, process_id)
    end
    
    # Finds a statement inside a process
    def statement(process_id, statement_id)
      process = process(process_id)
      process ? process.statement_by(:identifier, statement_id) : nil
    end
    
  end # class Engine
end # module CliPrEasy