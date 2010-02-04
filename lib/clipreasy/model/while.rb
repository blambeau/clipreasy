module CliPrEasy
  module Model

    #
    # While clause used inside process definition.
    #
    class While < Statement
      
      # Condition
      attr_accessor :condition
      
      # Then clause
      attr_reader :then_clause
      
      # Creates an until clause instance
      def initialize(condition, then_clause)
        raise ArgumentError, "Missing condition in While" unless condition
        raise ArgumentError, "Missing then_clause in While" unless Statement===then_clause
        @condition, @then_clause = condition, then_clause
        then_clause.parent = self
      end
      
      # See Statement.depth_first_search
      def depth_first_search(&block)
        raise ArgumentError, "Missing block in depth_first_search" unless block
        yield(self)
        then_clause.depth_first_search(&block)
      end
      
    end # class While

  end # module Model
end # module CliPrEasy