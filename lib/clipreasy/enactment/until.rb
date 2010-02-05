module CliPrEasy
  module Enactment

    #
    # Until clauses inside a process definition.
    #
    module Until
      
      # See Statement.start
      def start(parent_exec)
        my_exec = parent_exec.started(self)
        #puts "Starting until #{condition.inspect}"
        value = my_exec.evaluate(condition)
        if value
          parent.ended(self, my_exec)
        else
          then_clause.start(my_exec)
        end
      end
            
      # See Statement.ended
      def ended(child, child_context)
        my_context = child_context.close
        value = my_context.evaluate(condition)
        if value
          parent.ended(self, my_context)
        else
          then_clause.start(my_context)
        end
      end
      
    end # module Until

  end # module Enactment
end # module CliPrEasy