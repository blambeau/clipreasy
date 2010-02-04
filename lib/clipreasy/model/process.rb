module CliPrEasy
  module Model
    
    # 
    # Main level of statement hierarchy in process definitions, the Process itself.
    #
    class Process < Statement
      include Enumerable
      
      # Main statement
      attr_reader :main
      
      # Creates a workflow instance
      def initialize(main)
        raise ArgumentError, "Missing main statement in Process" unless Statement===main
        @main = main
        self.parent = self
        main.parent = self
        each_with_index{|s, i| s.identifier = i}
      end
      
      # Returns the main process, being self
      def process
        self
      end
      
      # Returns a statement by its token
      def statement(identifier)
        @statements = inject({}){|memo,s| memo[s.idenfifier] = s; memo} unless @statements
        @statements[identifier]
      end
      
      # See Statement.depth_first_search
      def depth_first_search(&block)
        raise ArgumentError, "Missing block in depth_first_search" unless block
        yield(self)
        main.depth_first_search(&block)
      end
      alias :each :depth_first_search
      
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

  end # module Model
end # module CliPrEasy