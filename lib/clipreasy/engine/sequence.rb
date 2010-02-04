module CliPrEasy
  module Engine

    #
    # Sequence inside a process definition.
    #
    class Sequence < Statement
      
      # Statements in the sequence
      attr_reader :statements
      
      # Creates a sequence element
      def initialize(statements)
        raise ArgumentError, "Missing statements in Sequence" unless Array===statements
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
    
  end # module Engine
end # module CliPrEasy