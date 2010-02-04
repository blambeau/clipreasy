module CliPrEasy
  module Model
    
    # 
    # Main level of statement hierarchy in process definitions, the Process itself.
    #
    class Process < Statement
      
      # See Statement.start
      def start(context)
        main.start(context)
      end
      
      # See Statement.ended
      def ended(child, child_context)
        my_context = child_context.close
        my_context.close
        []
      end
      
    end # class Process

  end # module Model
end # module CliPrEasy