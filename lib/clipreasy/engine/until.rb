module CliPrEasy
  module Engine

    #
    # Until clauses inside a process definition
    #
    class Until < Statement
      
      # Condition
      attr_accessor :condition
      
      # Then clause
      attr_reader :then_clause
      
      # Creates an until clause instance
      def initialize(condition, then_clause)
        @condition, @then_clause = condition, then_clause
        then_clause.parent = self
      end
      
      # Recursively visits the process
      def depth_first_search(&block)
        yield self
        then_clause.depth_first_search(&block)
      end
      
      # Starts the activity
      def start(context)
        my_context = context.started(self)
        if value = my_context.evaluate(condition)
          parent.ended(self, my_context)
        else
          then_clause.start(my_context)
        end
      end
            
      # Fired by children when they are ended
      def ended(child, child_context)
        my_context = child_context.close
        if value = my_context.evaluate(condition)
          parent.ended(self, my_context)
        else
          then_clause.start(my_context)
        end
      end
      
    end # class Until

  end # module Engine
end # module CliPrEasy