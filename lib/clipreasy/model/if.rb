module CliPrEasy
  module Model
    class If < Statement
      
      # Condition
      attr_reader :condition
      
      # Then clause
      attr_reader :then_clause
      
      # Else clause
      attr_reader :else_clause
      
      # Creates a If statement
      def initialize(condition, then_clause, else_clause)
        @condition, @then_clause, @else_clause = condition, then_clause, else_clause
        @then_clause.parent = self
        @else_clause.parent = self if @else_clause
      end
      
      # See Statement.depth_first_search
      def depth_first_search(&block)
        raise ArgumentError, "Missing block in depth_first_search" unless block
        yield(self)
        then_clause.depth_first_search(&block)
        else_clause.depth_first_search(&block) if else_clause
      end
      
    end # class If
  end # module Model
end # module CliPrEasy