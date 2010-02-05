module CliPrEasy
  module Enactment
    module Memory
      # Implements AbstractProcessExecution for an in-memory execution
      class ProcessExecution < ::CliPrEasy::Enactment::AbstractProcessExecution
        
        # Creates a process execution instance
        def initialize(factory, enacter, process)
          @factory, @enacter, @process = factory, enacter, process
          @children = []
          @status = :pending
        end
        
        ###################################################################################
        ### About execution hierarchy
        ###################################################################################
      
        # Returns the execution of the main statement
        def main_execution
          @children[0]
        end
      
        ###################################################################################
        ### About execution state
        ###################################################################################
      
        # Returns true if this execution is currently pending, false otherwise
        def pending?
          @status == :pending
        end
      
        # Returns true if this execution is ended, false otherwise
        def ended?
          @status == :ended
        end
      
        ###################################################################################
        ### About execution itself
        ###################################################################################
      
        # Creates a StatementExecution instance for who
        def started(who, *args)
          @children << @factory.factor_statement_execution(@enacter, self, nil, who)
          @children[0]
        end
        
        # Closes this process execution
        def close
          @status = :ended
          nil
        end
        
      end # class ProcessExecution
    end # module Memory
  end # module Enactment
end # module CliPrEasy