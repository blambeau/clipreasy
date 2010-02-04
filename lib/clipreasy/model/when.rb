module CliPrEasy
  module Model

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
        raise ArgumentError, "Missing value in When" unless value
        raise ArgumentError, "Missing then_clause in When" unless Statement===then_clause
        @value, @then_clause = value, then_clause
        then_clause.parent = self
      end
      
      # See Statement.depth_first_search
      def depth_first_search(&block)
        raise ArgumentError, "Missing block in depth_first_search" unless block
        yield(self)
        then_clause.depth_first_search(&block)
      end
      
      # See Statement.start
      def start(context)
        my_context = context.started(self)
        then_clause.start(my_context)
      end
            
      # See Statement.ended
      def ended(child, child_context)
        parent.ended(self, child_context.close)
      end
      
    end # class When

  end # module Model
end # module CliPrEasy