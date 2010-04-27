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
      def start(scope)
        # evaluate condition value
        my_scope = scope.branch(self)
        value = my_scope.evaluate(condition)
        
        # see clauses and start the good ones
        started = children.collect do |clause|
          clause_value = my_scope.evaluate(clause.value)
          value===clause_value ? clause.start(my_scope) : nil
        end.flatten.compact
        
        if started.empty?
          parent_in_execution.ended(self, my_scope.close)
        else
          my_scope.set(:started, started.size)
          my_scope.set(:ended, 0)
          started
        end
      end
            
      # See Statement.ended
      def ended(child, my_scope)
        my_scope.set(:ended, my_scope.get(:ended)+1)
        if (my_scope.get(:ended) == my_scope.get(:started))
          parent_in_execution.ended(self, my_scope.close)
        else
          []
        end
      end
      
    end # module Decision

  end # module Enactment
end # module CliPrEasy