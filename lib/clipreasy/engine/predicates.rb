module CliPrEasy
  module Engine
    class Predicates
  
      # Underlying process execution
      attr_reader :process_execution
  
      # Creates a predicates instance
      def initialize(database, process_execution)
        @database, @process_execution = database, process_execution
      end
  
      # Finds the bulk data attached to the last execution of an
      # activity whose code is provided
      def last_activity_data(s_code)
        tuple = @database[:last_activities].filter(:process_execution => process_execution, :s_code => s_code).first
        bulkdata = ::JSON.parse(tuple[:se_bulkdata])
        raise "Unexpected bulkdata #{bulkdata}" unless Hash===bulkdata
        bulkdata ? bulkdata.methodize : nil
        
      end
  
    end # class Predicates
  end # module Engine
end # module CliPrEasy