module CliPrEasy
  module Enactment
    
    #
    # Activity inside a process.
    #
    # An Activity is the lower level in statement abstractions. It provides
    # a basic unit of work, typically made by only one actor. 
    #
    module Activity

      # See Statement.start. Returns a singleton array with the result of this 
      # activity being started on the context instance.
      def start(scope)
        [scope.branch(self)]
      end
      
      # See Statement.ended. This method raises an IllegalStateError as activities
      # have no child.
      def ended(child, scope)
        raise ::CliPrEasy::IllegalStateError, "Activity.ended should never be called."
      end
      
      # Closes this activity. This callback method exists on activities only and fires 
      # an ended message to their parent.
      def resume(my_scope)
        parent_in_execution.ended(self, my_scope.close)
      end
      
    end # module Activity
  end # module Enactment
end # module CliPrEasy