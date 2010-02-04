module CliPrEasy
  module Model

    #
    # Decision inside a process.
    #
    # A decision has a given abstraction condition and outgoing when clauses
    # (see When).
    #
    class Decision < Statement
      
      # See Statement.start
      def start(context)
        # evaluate condition value and fire
        my_context = context.started(self)
        value = my_context.evaluate(condition)
        
        # see clauses and start the good ones
        started = clauses.collect do |clause|
          clause_value = my_context.evaluate(clause.value)
          value===clause_value ? clause.start(my_context) : nil
        end.flatten.compact
        
        started.empty? ? parent.ended(self, my_context) : started
      end
            
      # See Statement.ended
      def ended(child, child_context)
        parent.ended(self, child_context.close)
      end
      
    end # class Decision

  end # module Model
end # module CliPrEasy