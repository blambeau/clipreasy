module CliPrEasy
  module Engine

    #
    # Until clauses inside a process definition.
    #
    class Until < Statement
      
      # Condition
      attr_accessor :condition
      
      # Then clause
      attr_reader :then_clause
      
      # Creates an until clause instance
      def initialize(condition, then_clause)
        raise ArgumentError, "Missing condition in Until" unless condition
        raise ArgumentError, "Missing then_clause in Until" unless Statement===then_clause
        @condition, @then_clause = condition, then_clause
        then_clause.parent = self
      end
      
      # See Statement.depth_first_search
      def depth_first_search(memo = nil, &block)
        raise ArgumentError, "Missing block in depth_first_search" unless block
        yield(memo,self)
        then_clause.depth_first_search(memo, &block)
        memo
      end
      
      # See Statement.start
      def start(context)
        my_context = context.started(self)
        then_clause.start(my_context)
      end
            
      # See Statement.ended
      def ended(child, child_context)
        my_context = child_context.close
        value = my_context.evaluate(condition)
        if value
          parent.ended(self, my_context)
        else
          then_clause.start(my_context)
        end
      end
      
    end # class Until

  end # module Engine
end # module CliPrEasy