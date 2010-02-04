module CliPrEasy
  module Engine
    
    # 
    # Main level of statement hierarchy in process definitions, the Process itself.
    #
    class Process < Statement
      
      # Main statement
      attr_reader :main
      
      # Creates a workflow instance
      def initialize(main)
        raise ArgumentError, "Missing main statement in Process" unless Statement===main
        @main = main
        self.parent = self
        main.parent = self
      end
      
      # Returns the main process, being self
      def process
        self
      end
      
      # Returns a statement by its token
      def statement(identifier)
        @statements = depth_first_search({}){|memo,s| memo[s.idenfifier] = s} unless @statements
        @statements[token]
      end
      
      # See Statement.depth_first_search
      def depth_first_search(memo = nil, &block)
        raise ArgumentError, "Missing block in depth_first_search" unless block
        yield(memo,self)
        main.depth_first_search(memo, &block)
        memo
      end
      
      # Inspects this process
      def inspect
        "#{self.class}::#{code}"
      end      
      
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

  end # module Engine
end # module CliPrEasy