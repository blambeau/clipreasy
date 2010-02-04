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
      def depth_first_search(&block)
        raise ArgumentError, "Missing block in depth_first_search" unless block
        yield(self)
        statements.each{|c| c.depth_first_search(&block)}
      end
          
    end # class Parallel
    
  end # module Model
end # module CliPrEasy