module CliPrEasy
  module Enactment
    # 
    # Describes the precise API to be considered a valid execution factory. This class
    # is a specification marker. It is not intended to be subclasses or instantiated 
    # directly.
    #
    class ExecutionFactory
      
      #
      # Factors a process execution instance when execution of a process is started 
      # by an Enacter instance. 
      #
      # Returned result is expected to be a subclass of AbstractProcessExecution,
      # respecting the specification described there.
      #
      def factor_process_execution(enacter, process, &block)
        raise ::NotImplementedError, "ExecutionFactory.factor_process_execution must be implemented"
      end
      
      #
      # Factors a statement execution instance when execution of a statement is started 
      # by an Enacter instance, inside a process execution previously factored by 
      # factor_process_execution and a parent statement execution.
      #
      # Returned result is expected to be a subclass of AbstractStatementExecution,
      # respecting the specification described there.
      #
      def factor_statement_execution(enacter, process_execution, parent, statement, &block)
        raise ::NotImplementedError, "ExecutionFactory.factor_statement_execution must be implemented"
      end
      
    end # class ExecutionFactory
  end # module Enactment
end # module CliPrEasy