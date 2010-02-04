module CliPrEasy
  module Model

    #
    # Until clauses inside a process definition.
    #
    class Until < Statement
      
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

  end # module Model
end # module CliPrEasy