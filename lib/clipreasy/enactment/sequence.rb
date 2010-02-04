module CliPrEasy
  module Enactment

    #
    # Sequence inside a process definition.
    #
    module Sequence
      
      # See Statement.start
      def start(context)
        my_context = context.started(self)
        statements.first.start(my_context)
      end
      
      # See Statement.ended
      def ended(child, child_context)
        my_context = child_context.close
        if child==statements.last
          parent.ended(self, my_context)
        else
          statements[statements.index(child)+1].start(my_context)
        end
      end
          
    end # module Sequence
    
  end # module Enactment
end # module CliPrEasy