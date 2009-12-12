module CliPrEasy
  module Engine
    
    # 
    # Main level of statement hierarchy in process definitions, the Proces itself.
    #
    class Process < Statement
      
      #############################################################################################
      ### Instance variables
      #############################################################################################
      
      # Process identifier
      attr_reader :id
      
      # Main statement
      attr_reader :main
      
      # Creates a workflow instance
      def initialize(id, main)
        @id, @main = id, main
        main.parent = self
      end
      
      # Returns the main process, being self
      def process
        self
      end
      
      # Recursively visits the process
      def depth_first_search(&block)
        yield self
        main.depth_first_search(&block)
      end
      
      # Inspects this process
      def inspect
        "#{self.class}::#{id}"
      end      
      
      #############################################################################################
      ### Process execution
      #############################################################################################
      
      # Starts the process with a given context
      def start(context=nil)
        if context.nil?
          my_context = ProcessContext.new(nil, self)
        else
          my_context = context.started(self)
        end
        main.start(my_context)
      end
      
      # Fired by children when they are ended
      def ended(child, child_context)
        my_context = child_context.close
        my_context.close
      end
      
    end # class Process

  end # module Engine
end # module CliPrEasy