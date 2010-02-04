module CliPrEasy
  module Model

    #
    # Sequence inside a process definition.
    #
    class Sequence < Statement
      
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
          
    end # class Sequence
    
  end # module Model
end # module CliPrEasy