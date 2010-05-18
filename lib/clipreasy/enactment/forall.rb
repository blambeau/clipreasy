module CliPrEasy
  module Enactment
    #
    # Forall inside a process definition.
    #
    module Forall
      
      # See Statement.start
      def start(scope)
        my_scope = scope.branch(self)
        
        # Find iterated and start child on each of them
        started = my_scope.evaluate(iterated).collect do |i|
          i_scope = my_scope.branch(self)
          i_scope.set(as, i)
          self.then.start(i_scope)
        end.flatten

        # Continue now
        if started.empty?
          parent_in_execution.ended(self, my_scope.close)
        else
          my_scope.set(:started, started.size)
          my_scope.set(:ended, 0)
          started
        end
      end
      
      # See Statement.ended
      def ended(child, i_scope)
        my_scope = i_scope.close
        my_scope.set(:ended, my_scope.get(:ended)+1)
        if (my_scope.get(:ended) == my_scope.get(:started))
          parent_in_execution.ended(self, my_scope.close)
        else
          []
        end
      end
          
    end # module Forall
  end # module Enactment
end # module CliPrEasy