module CliPrEasy
  module Enactment

    #
    # Decision inside a process.
    #
    # A decision has a given abstraction condition and outgoing when clauses
    # (see When).
    #
    module Decision
      
      # See Statement.start
      def start(context)
        # evaluate condition value and fire
        my_context = context.started(self)
        value = my_context.evaluate(condition)
        
        # see clauses and start the good ones
        started = children.collect do |clause|
          clause_value = my_context.evaluate(clause.value)
          value===clause_value ? clause.start(my_context) : nil
        end.flatten.compact
        
        started.empty? ? parent_in_execution.ended(self, my_context) : started
      end
            
      # See Statement.ended
      def ended(child, child_context)
        parent_in_execution.ended(self, child_context.close)
      end
      
    end # module Decision

  end # module Enactment
end # module CliPrEasy