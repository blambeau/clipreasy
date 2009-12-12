module CliPrEasy
  module Engine

    #
    # Parallel statement inside a process definition.
    #
    class Parallel < Statement
      include Enumerable
      
      # Statements in the parallel
      attr_reader :statements
      
      # Creates a parallel element
      def initialize(statements)
        @statements = statements
        statements.each {|c| c.parent = self}
      end
      
      # Returns the number of statements in the sequence
      def size
        statements.size
      end
      
      # Yields the block with each element of the parallel.
      def each 
        statements.each{|s| yield s}
      end
      
      # Recursively visits the process
      def depth_first_search(&block)
        yield self
        statements.each{|c| c.depth_first_search(&block)}
      end
      
      # Starts the decision node
      def start(context)
        my_context = context.started(self)
        statements.collect {|s| s.start(my_context)}.flatten
      end
      
      # Fired by children when they are ended
      def ended(child, child_context)
        my_context = child_context.close
        my_context.all_children_ended? ? parent.ended(self, my_context) : []
      end
          
    end # class Parallel
    
  end # module Engine
end # module CliPrEasy