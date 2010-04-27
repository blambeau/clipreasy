module CliPrEasy
  module Enactment

    #
    # Until clauses inside a process definition.
    #
    module Until
      
      # See Statement.start
      def start(scope)
        my_scope = scope.branch(self)
        if my_scope.evaluate(condition)
          parent_in_execution.ended(self, my_scope.close)
        else
          self.then.start(my_scope)
        end
      end
            
      # See Statement.ended
      def ended(child, my_scope)
        if my_scope.evaluate(condition)
          parent_in_execution.ended(self, my_scope.close)
        else
          self.then.start(my_scope)
        end
      end
      
    end # module Until

  end # module Enactment
end # module CliPrEasy