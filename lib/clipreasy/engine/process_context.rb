module CliPrEasy
  module Engine
    
    #
    # Provides the precise API for being a process execution context.
    #
    # This class is intended to be duck-typed or sublcassed to implement specific 
    # process execution context strategies (in memory, backed on disked, etc.)
    #
    class ProcessContext
      
      ###################################################################################
      ### About execution context link to process statements
      ###################################################################################
      
      # Returns the process statement attached to this execution context
      def statement
        raise "ProcessContext.statement should be implemented by subclasses"
      end
      
      # Returns the process under execution. This method calls statement.process as an
      # a default implementation
      def process
        statement.process
      end
      
      ###################################################################################
      ### About execution context hierarchy
      ###################################################################################
      
      # Returns the parent execution context
      def parent
        raise "ProcessContext.parent should be implemented by subclasses"
      end
      
      # Returns children execution contexts, an empty array if no one
      def children
        raise "ProcessContext.children should be implemented by subclasses"
      end
      
      ###################################################################################
      ### About execution context state
      ###################################################################################
      
      # Returns true if this execution context is currently pending, false otherwise
      def pending?
        raise "ProcessContext.pending? should be implemented by subclasses"
      end
      
      # Returns true if this execution context is ended, false otherwise
      def ended?
        raise "ProcessContext.ended? should be implemented by subclasses"
      end
      
      # Checks if all children execution context are ended
      # This method is implemented by default through the children accesssor but may
      # be overriden for better strategies.
      def all_children_ended?
        children.all?{|c| c.ended?}
      end
      
      ###################################################################################
      ### About execution itself
      ###################################################################################
      
      #
      # Fired when a statement _who_ is started. 
      #
      # By construction, _who_ is always a child of the attached statement (pre-condition
      # not checked). Optional arguments may be passed by specific statements, see their
      # documentation for details.
      #
      # This method is expected to branch the execution context to provide a children 
      # context for _who_'s execution. This execution context child MUST be returned by
      # the method and provided in _children_ later.
      #
      # This method is not intended to be invoked outside the process framework itself
      # (that is, by Statement subclasses).
      #
      def started(who, *args)
        raise "ProcessContext.started should be implemented by subclasses"
      end
      
      #
      # Closes this execution context and returns its parent.
      #
      # This execution context should be currently pending, strange behavior could occur
      # otherwise. After invocation, the execution context is expected to be ended.
      #
      # This method is not intended to be invoked outside the process framework itself
      # (that is, by Statement subclasses).
      #
      def close
        raise "ProcessContext.close should be implemented by subclasses"
      end
      
      #
      # Let the engine know that this pending activity is now considered ended. 
      #
      # The default implementation closes the current activity statement and returns new
      # execution contexts fired by process execution semantics.
      # Invoking this method only makes sense on context linked to an Activity statement.
      # An error is raised by the default implementation if this pre-condition is not 
      # respected.
      #
      # Unlike _started_ and _close_ this method is considered public and intended to be
      # used to let the process restore its execution when an activity is considered ended
      # in the environment
      #
      def activity_ended
        raise "Statement is expected to be an Activity but was #{statement}" unless Activity===statement
        statement.close(self)
      end
      
      #
      # Evaluates an expression that makes sense in the environment.
      #
      # This method is typically used by decision nodes, until and while condition and so on
      # to get real values in order to respect process execution semantics.
      #
      def evaluate(expression)
        raise "ProcessContext.evaluate should be implemented by subclasses"
      end
      
    end # class ProcessContext
    
  end # module Engine
end # module CliPrEasy