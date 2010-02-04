module CliPrEasy
  module Enactment
    
    # 
    # Main level of statement hierarchy in process definitions, the Process itself.
    #
    module Process
      
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
      
    end # module Process

  end # module Enactment
end # module CliPrEasy