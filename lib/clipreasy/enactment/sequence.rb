module CliPrEasy
  module Enactment

    #
    # Sequence inside a process definition.
    #
    module Sequence
      
      # See Statement.start
      def start(parent_execution)
        my_exec = parent_execution.started(self)
        #puts "Starting sequence #{self.business_id} leads to #{statements.first.business_id}"
        statements.first.start(my_exec)
      end
      
      # See Statement.ended
      def ended(child, child_context)
        my_context = child_context.close
        if child==statements.last
          #puts "Closing sequence #{self.business_id} with #{parent}"
          parent.ended(self, my_context)
        else
          statements[statements.index(child)+1].start(my_context)
        end
      end
          
    end # module Sequence
    
  end # module Enactment
end # module CliPrEasy