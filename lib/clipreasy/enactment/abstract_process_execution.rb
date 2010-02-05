module CliPrEasy
  module Enactment
    #
    # Provides the precise API for being a process execution.
    #
    # This class is intended to be duck-typed or sublcassed to implement specific 
    # statement execution strategies (in memory, backed on disked, etc.)
    #
    class AbstractProcessExecution
      
      ###################################################################################
      ### About execution hierarchy
      ###################################################################################
      
      # Returns the execution of the main statement
      def main_execution
        raise "AbstractProcessExecution.main_execution should be implemented by subclasses"
      end
      
      ###################################################################################
      ### About execution state
      ###################################################################################
      
      # Returns true if this execution is currently pending, false otherwise
      def pending?
        raise "AbstractProcessExecution.pending? should be implemented by subclasses"
      end
      
      # Returns true if this execution is ended, false otherwise
      def ended?
        raise "AbstractProcessExecution.ended? should be implemented by subclasses"
      end
      
      ###################################################################################
      ### About execution itself
      ###################################################################################
      
      #
      # Closes this process execution and returns self.
      #
      # This execution should be currently pending, strange behavior could occur
      # otherwise. After invocation, the execution is expected to be ended.
      #
      # This method is not intended to be invoked outside the process framework itself
      # (that is, by Statement subclasses).
      #
      def close
        raise "AbstractProcessExecution.close should be implemented by subclasses"
      end
      
      #
      # Fired when a statement _who_ is started, which is the main process statement, 
      # by construction
      #
      # This method is expected to create an AbstractStatementExecution instance, providing
      # who's execution context. This execution child MUST be returned by the method.
      #
      # This method is not intended to be invoked outside the process framework itself
      # (that is, by the Statement subclasses).
      #
      def started(who, *args)
        raise "AbstractProcessExecution.started should be implemented by subclasses"
      end
      
    end # class AbstractProcessExecution
  end # module Enactment
end # module CliPrEasy