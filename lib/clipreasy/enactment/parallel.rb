module CliPrEasy
  module Model

    #
    # Parallel statement inside a process definition.
    #
    class Parallel < Statement
      
      # See Statement.start
      def start(context)
        my_context = context.started(self)
        statements.collect {|s| s.start(my_context)}.flatten
      end
      
      # See Statement.ended
      def ended(child, child_context)
        my_context = child_context.close
        my_context.all_children_ended? ? parent.ended(self, my_context) : []
      end
          
    end # class Parallel
    
  end # module Model
end # module CliPrEasy