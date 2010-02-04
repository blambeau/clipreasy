module CliPrEasy
  module Engine
    
    #
    # Activity inside a process.
    #
    # An Activity is the lower level in statement abstractions. It provides
    # a basic unit of work, typically made by only one actor. 
    #
    class Activity < Statement

      # See Statement.depth_first_search
      def depth_first_search(memo = nil, &block)
        raise ArgumentError, "Missing block in depth_first_search" unless block
        yield(memo, self)
        memo
      end
      
      # See Statement.start. Returns a singleton array with the result of this 
      # activity being started on the context instance.
      def start(context)
        [context.started(self)]
      end
      
      # See Statement.ended. This method raises an IllegalStateError as activities
      # have no child.
      def ended(child, child_context)
        raise ::CliPrEasy::IllegalStateError, "Activity.ended should never be called."
      end
      
      # Closes this activity. This callback method exists on activities only and fires 
      # an ended message to their parent.
      def close(context)
        parent.ended(self, context)
      end
      
    end # class Activity
  end # module Engine
end # module CliPrEasy