module CliPrEasy
  module Model

    #
    # Parallel statement inside a process definition.
    #
    class Parallel < Statement
      
      # Statements in the parallel
      attr_reader :statements
      
      # Creates a parallel element
      def initialize(statements)
        raise ArgumentError, "Missing statements in Parallel" unless Array===statements
        @statements = statements
        statements.each {|c| c.parent = self}
      end
      
      # Returns the number of statements in the sequence
      def size
        statements.size
      end
      
      # See Statement.depth_first_search
      def depth_first_search(memo = nil, &block)
        raise ArgumentError, "Missing block in depth_first_search" unless block
        yield(memo,self)
        statements.each{|c| c.depth_first_search(memo,&block)}
        memo
      end
      
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