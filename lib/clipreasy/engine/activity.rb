module CliPrEasy
  module Engine
    
    #
    # Activity inside a process.
    #
    # An Activity is the lower level in statement abstractions. It provides
    # a basic unit of work, typically made by only one actor. 
    #
    class Activity < Statement

      # Creates an activity instance
      def initialize(id)
        @id = id
      end
      
      # Recursively visits the process
      def depth_first_search
        yield self
      end
      
      # Starts the activity
      def start(context)
        context.started(self)
      end
      
      # Closes this activity
      def close(context)
        parent.ended(self, context)
      end
      
      # Fired by children when they are ended
      def ended(child, child_context)
        raise "Method ended should never been called on Activity"
      end
      
    end # class Activity
  end # module Engine
end # module CliPrEasy