module CliPrEasy
  module Enactment

    #
    # While clause used inside process definition.
    #
    module While
      
      # See Statement.start
      def start(scope)
        my_scope = scope.branch(self)
        if my_scope.evaluate(condition)
          self.then.start(my_scope)
        else 
          parent_in_execution.ended(self, my_scope.close)
        end
      end
            
      # See Statement.ended
      def ended(child, my_scope)
        if my_scope.evaluate(condition)
          self.then.start(my_scope)
        else 
          parent_in_execution.ended(self, my_scope.close)
        end
      end
      
    end # module While

  end # module Enactment
end # module CliPrEasy