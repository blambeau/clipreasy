module CliPrEasy
  module Enactment
    #
    # Provides the precise API for being a process execution.
    #
    # This class is intended to be duck-typed or sublcassed to implement specific 
    # statement execution strategies (in memory, backed on disked, etc.)
    #
    class AbstractProcessExecution
      
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