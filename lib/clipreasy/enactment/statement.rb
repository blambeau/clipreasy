module CliPrEasy
  module Model

    #
    # Abstract statement inside a process. Statement is the parent class of all
    # process abstractions (activity, sequence, parallel, ...). It proposes unique
    # identifiers for those abstractions, markable design pattern and basic "query" 
    # utilities.
    #
    # Children have to implement the following methods:
    #
    # * depth_first_search, a depth first search visit of the process tree.
    # * start, the algorithm to make the statement living inside a process execution.
    # * stop, the algorithm to make the statement ended inside a process execution.
    #
    class Statement
      
      #
      # Starts the statement inside an execution context. Returns terminal execution contexts
      # that have been started due to this start.
      #
      # This method MUST be implemented bu sublasses and raises an exception 
      # by default.
      #
      def start(context)
        raise ::NotImplementedError, "Bad Statement subclass #{self.class}: start MUST by implemented."
      end
      
      #
      # Fired by children when they are ended. Returns terminal execution contexts
      # that have been started due to this end.
      #
      def ended(child, child_context)
        raise ::NotImplementedError, "Bad Statement subclass #{self.class}: ended MUST by implemented."
      end
          
    end # class Statement

  end # module Model
end # module CliPrEasy
