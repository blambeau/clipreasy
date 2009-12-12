module CliPrEasy
  module Engine

    #
    # Sequence inside a process definition
    #
    class Sequence < Statement
      include Enumerable
      
      # Statements in the sequence
      attr_reader :statements
      
      # Creates a sequence element
      def initialize(statements)
        @statements = statements
        statements.each {|c| c.parent = self}
      end
      
      # Returns the number of statements in the sequence
      def size
        statements.size
      end
      
      # Yields the block with each element of the sequence
      def each 
        statements.each{|s| yield s}
      end
      
      # Returns the index-th statement in the sequence
      def [](index)
        statements[index]
      end
      
      # Recursively visits the process
      def depth_first_search(&block)
        yield self
        statements.each{|c| c.depth_first_search(&block)}
      end
      
      # Starts the sequence
      def start(context)
        my_context = context.started(self)
        statements.first.start(my_context)
      end
      
      #
      # Fired by children when they are ended
      #
      def ended(child, child_context)
        my_context = child_context.close
        if child==statements.last
          parent.ended(self, my_context)
        else
          statements[statements.index(child)+1].start(my_context)
        end
      end
          
    end # class Sequence
    
  end # module Engine
end # module CliPrEasy