module CliPrEasy
  module Enactment

    #
    # When clauses used in decisions.
    #
    module When
      
      # See Statement.start
      def start(context)
        my_context = context.started(self)
        then_clause.start(my_context)
      end
            
      # See Statement.ended
      def ended(child, child_context)
        parent.ended(self, child_context.close)
      end
      
    end # module When

  end # module Enactment
end # module CliPrEasy