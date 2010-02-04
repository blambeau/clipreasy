module CliPrEasy
  module Model

    #
    # When clauses used in decisions.
    #
    class When < Statement
      
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