module CliPrEasy
  module Engine

    #
    # When clauses used in decisions.
    #
    class When < Statement
      
      # Conditional value
      attr_accessor :value
      
      # Then clause
      attr_reader :then_clause
      
      # Creates a when clause instance
      def initialize(value, then_clause)
        @value, @then_clause = value, then_clause
        then_clause.parent = self
      end
      
      # Recursively visits the process
      def depth_first_search(&block)
        yield self
        then_clause.depth_first_search(&block)
      end
      
      # Starts the when clause
      def start(context)
        my_context = context.started(self)
        then_clause.start(my_context)
      end
            
      # Fired by children when they are ended
      def ended(child, child_context)
        parent.ended(self, child_context.close)
      end
      
    end # class When

  end # module Engine
end # module CliPrEasy