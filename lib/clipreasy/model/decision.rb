module CliPrEasy
  module Model

    #
    # Decision inside a process.
    #
    # A decision has a given abstraction condition and outgoing when clauses
    # (see When).
    #
    class Decision < Statement
      
      # Associated condition
      attr_reader :condition
      
      # Decision clauses
      attr_reader :clauses
      
      # Creates a Decision instance
      def initialize(condition, clauses)
        raise ArgumentError, "Missing condition in Decision" unless condition
        raise ArgumentError, "Missing when clauses in Decision" unless Array===clauses
        @condition, @clauses = condition, clauses
        clauses.each {|c| c.parent = self}
      end
      
      # See Statement.depth_first_search
      def depth_first_search(&block)
        raise ArgumentError, "Missing block in depth_first_search" unless block
        yield(self)
        clauses.each{|c| c.depth_first_search(&block)}
      end
      
    end # class Decision

  end # module Model
end # module CliPrEasy