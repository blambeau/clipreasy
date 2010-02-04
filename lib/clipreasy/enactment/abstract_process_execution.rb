module CliPrEasy
  module Enactment

    #
    # Provides the precise API for being a process execution.
    #
    # This class is intended to be duck-typed or sublcassed to implement specific 
    # statement execution strategies (in memory, backed on disked, etc.)
    #
    class AbstractProcessExecution < AbstractStatementExecution
    end # class AbstractProcessExecution
    
  end # module Enactment
end # module CliPrEasy