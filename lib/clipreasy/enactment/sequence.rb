module CliPrEasy
  module Enactment

    #
    # Sequence inside a process definition.
    #
    module Sequence
      
      # See Statement.start
      def start(scope)
        my_scope = scope.branch(self)
        children.first.start(my_scope)
      end
      
      # See Statement.ended
      def ended(child, my_scope)
        if child == children.last
          parent_in_execution.ended(self, my_scope.close)
        else
          children[children.index(child)+1].start(my_scope)
        end
      end
          
    end # module Sequence
    
  end # module Enactment
end # module CliPrEasy