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
      include Markable
      
      # Unique identifier of this statement. This identifier is always the position
      # of the statement in a depth_first_search visit (the process itself being 
      # identified by 0)
      attr_accessor :identifier
      
      # Optional unique identifier that can be attached by business users. Uniqueness
      # of the identifier is not guaranteed by this class.
      attr_accessor :business_id
      
      # Parent statement, or the process itself
      attr_accessor :parent
      
      # Returns the main process, top level of the hierarchy. This method MUST be
      # overriden by the Process itself.
      def process
        raise ::CliPrEasy::IllegalStateError, "Bad Statement subclass #{self.class}, missing parent" unless parent
        @process ||= parent.process
      end
      
      #
      # Makes a depth first search of the process tree. This method yields the block 
      # with each statement in turn (first and only block argument), following a 
      # depth first search algorithm (actually: self -> dfs(children)).
      #
      # This method MUST be implemented by subclasses.
      #
      def depth_first_search(&block)
        raise ::NotImplementedError, "Bad Statement subclass #{self.class}: depth_first_search MUST be "\
                                     "implemented by subclasses."
      end
      
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
          
      # 
      # Inspects this statement
      #  
      def inspect
        self.class.name =~ /::([a-zA-Z0-9]+)$/
        business_id ? "#{$1}:#{business_id}" : "#{$1}:#{identifier}"
      end      
      
      protected :parent=, :identifier=
    end # class Statement

  end # module Model
end # module CliPrEasy
