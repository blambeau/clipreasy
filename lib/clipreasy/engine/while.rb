module CliPrEasy
  module Engine

    #
    # While clause used inside process definitions
    #
    class While < Statement
      
      # Condition
      attr_reader :condition
      
      # Then clause
      attr_reader :then_clause
      
      # Creates an until clause instance
      def initialize(condition, then_clause)
        @condition, @then_clause = condition, then_clause
        then_clause.parent = self
      end
      
      # Recursively visits the workflow
      def depth_first_search(&block)
        yield self
        then_clause.depth_first_search(&block)
      end
      
      # Starts the while statement
      def start(context)
        my_context = context.started(self)
        value = my_context.evaluate(condition)
        then_clause.start(my_context) if value
      end
            
      # Fired by children when they are ended
      def ended(child, child_context)
        my_context = child_context.close
        value = my_context.evaluate(condition)
        if value
          then_clause.start(my_context)
        else
          parent.ended(self, my_context)
        end
      end
      
    end # class While

  end # module Engine
end # module CliPrEasy