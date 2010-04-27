module CliPrEasy
  module Enactment

    #
    # When clauses used in decisions.
    #
    module When
      
      # See Statement.start
      def start(scope)
        my_scope = scope.branch(self)
        self.then.start(my_scope)
      end
            
      # See Statement.ended
      def ended(child, my_scope)
        parent_in_execution.ended(self, my_scope.close)
      end
      
    end # module When

  end # module Enactment
end # module CliPrEasy