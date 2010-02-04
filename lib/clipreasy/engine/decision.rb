module CliPrEasy
  module Engine

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
      def depth_first_search(memo = nil, &block)
        raise ArgumentError, "Missing block in depth_first_search" unless block
        yield(memo,self)
        clauses.each{|c| c.depth_first_search(memo, &block)}
        memo
      end
      
      # See Statement.start
      def start(context)
        # evaluate condition value and fire
        my_context = context.started(self)
        value = my_context.evaluate(condition)
        
        # see clauses and start the good ones
        started = clauses.collect do |clause|
          clause_value = my_context.evaluate(clause.value)
          value===clause_value ? clause.start(my_context) : nil
        end.flatten.compact
        
        started.empty? ? parent.ended(self, my_context) : started
      end
            
      # See Statement.ended
      def ended(child, child_context)
        parent.ended(self, child_context.close)
      end
      
    end # class Decision

  end # module Engine
end # module CliPrEasy