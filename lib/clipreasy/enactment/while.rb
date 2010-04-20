module CliPrEasy
  module Enactment

    #
    # While clause used inside process definition.
    #
    module While
      
      # See Statement.start
      def start(context)
        my_context = context.started(self)
        value = my_context.evaluate(condition)
        self.then.start(my_context) if value
      end
            
      # See Statement.ended
      def ended(child, child_context)
        my_context = child_context.close
        value = my_context.evaluate(condition)
        if value
          self.then.start(my_context)
        else
          parent_in_execution.ended(self, my_context)
        end
      end
      
    end # module While

  end # module Enactment
end # module CliPrEasy