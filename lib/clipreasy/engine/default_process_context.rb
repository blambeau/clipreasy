module CliPrEasy
  module Engine

    #
    # Abstracts the notion of process context.
    #
    # This class keeps the process state in memory and is intended to be sub-classed or duck-typed if 
    # the process state must be kept on disk or inside a database.
    #
    class DefaultProcessContext
      
      # Parent execution context
      attr_reader :parent
      
      # Children execution contexts
      attr_reader :children
      
      # The statement under execution
      attr_reader :statement
      
      # Context status
      attr_reader :status
      
      # Creates a context instance with parent context and pending
      # statement
      def initialize(parent, statement)
        @parent, @statement, @children = parent, statement, []
        @status = :started
      end
      
      # Fired when an activity is started
      def started(who, *args)
        subcontext = DefaultProcessContext.new(self, who)
        children << subcontext
        #puts "#{subcontext.inspect} has been started"
        subcontext
      end
      
      # Closes this execution context and returns its parent
      def close
        #puts "#{self.inspect} has been closed"
        @status = :ended
        parent
      end
      
      # Checks if all children execution contexts have been closed
      def all_children_ended?
        @children.all?{|c| c.status == :ended}
      end
      
      # Evaluates an expression
      def evaluate(expression)
        true
      end
      
      # Fires the end of the activity execution on which this context
      # has been freezed
      def activity_ended
        raise "Statement is expected to be an Activity but was #{statement}" unless Activity===statement
        statement.close(self)
      end
      
      # Inspects this context
      def inspect
        "#{statement.inspect}::#{object_id}"
      end

    end # class DefaultProcessContext

  end # module Engine
end # module CliPrEasy