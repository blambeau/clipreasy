module CliPrEasy
  module Enactment

    #
    # If-decision inside a process.
    #
    # A decision has a given abstraction condition and outgoing then and else
    # clauses.
    #
    module If
      
      # See Statement.start
      def start(context)
        # evaluate condition value and fire
        my_context = context.started(self)
        value = my_context.evaluate(condition)
        
        # see clauses and start the good ones
        started = if value
          then_clause.start(my_context)
        elsif else_clause
          else_clause.start(my_context)
        end
        
        started.nil? ? parent.ended(self, my_context) : started
      end
            
      # See Statement.ended
      def ended(child, child_context)
        parent.ended(self, child_context.close)
      end
      
    end # module Decision

  end # module Enactment
end # module CliPrEasy