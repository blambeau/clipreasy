module CliPrEasy
  module Enactment

    #
    # Parallel statement inside a process definition.
    #
    module Parallel
      
      # See Statement.start
      def start(scope)
        my_scope = scope.branch(self)
        started = children.collect {|s| s.start(my_scope)}.flatten
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
          
    end # module Parallel
    
  end # module Enactment
end # module CliPrEasy