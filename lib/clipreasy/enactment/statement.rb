module CliPrEasy
  module Enactment

    #
    # This module defines the common enactment API for all Statement classes.
    #
    # Children have to implement the following two methods:
    # * start, the algorithm to make the statement living inside a process execution.
    # * stop, the algorithm to make the statement ended inside a process execution.
    #
    module Statement
      
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

  end # module Enactment
end # module CliPrEasy
