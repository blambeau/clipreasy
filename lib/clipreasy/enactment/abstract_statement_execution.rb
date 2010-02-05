module CliPrEasy
  module Enactment
    
    #
    # Provides the precise API for being a statement execution.
    #
    # This class is intended to be duck-typed or sublcassed to implement specific 
    # statement execution strategies (in memory, backed on disked, etc.)
    #
    class AbstractStatementExecution
      
      ###################################################################################
      ### About execution link to process statements
      ###################################################################################
      
      # Returns the process statement attached to this statement execution
      def statement
        raise "StatementExecution.statement should be implemented by subclasses"
      end
      
      # Returns the process under execution. This method calls statement.process as an
      # default implementation
      def process
        statement.process
      end
      
      ###################################################################################
      ### About statement execution hierarchy
      ###################################################################################
      
      # Returns the parent execution
      def parent
        raise "StatementExecution.parent should be implemented by subclasses"
      end
      
      # Returns children executions, an empty array if no one
      def children
        raise "StatementExecution.children should be implemented by subclasses"
      end
      
      ###################################################################################
      ### About execution state
      ###################################################################################
      
      # Returns true if this execution is currently pending, false otherwise
      def pending?
        raise "StatementExecution.pending? should be implemented by subclasses"
      end
      
      # Returns true if this execution context is ended, false otherwise
      def ended?
        raise "StatementExecution.ended? should be implemented by subclasses"
      end
      
      #
      # Checks if all children executions are ended.
      #
      # This method is implemented by default through the children accesssor but may
      # be overriden for better strategies.
      #
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
      # This method is expected to branch this statement execution and provide a child
      # execution for _who_'s. This execution child MUST be returned by the method and 
      # provided in _children_ later.
      #
      # This method is not intended to be invoked outside the process framework itself
      # (that is, by Statement subclasses).
      #
      def started(who, *args)
        raise "StatementExecution.started should be implemented by subclasses"
      end
      
      #
      # Closes this statement execution and returns its parent.
      #
      # This execution context should be currently pending, strange behavior could occur
      # otherwise. After invocation, the execution context is expected to be ended.
      #
      # This method is not intended to be invoked outside the process framework itself
      # (that is, by Statement subclasses).
      #
      def close
        raise "StatementExecution.close should be implemented by subclasses"
      end
      
      #
      # Let the engine know that this pending activity is now considered ended. 
      #
      # The default implementation closes the current activity statement and returns new
      # statement execution instances fired by the process execution semantics.
      # Invoking this method only makes sense on context linked to an Activity statement.
      # An error is raised by the default implementation if this pre-condition is not 
      # respected.
      #
      # Unlike _started_ and _close_ this method is considered public and intended to be
      # used to let the process restore its execution when an activity is considered ended
      # in the environment.
      #
      def activity_ended
        raise "Statement is expected to be an Activity but was #{statement}" unless ::CliPrEasy::Model::Activity===statement
        statement.close(self)
      end
      
      #
      # Evaluates an expression that makes sense in the environment.
      #
      # This method is typically used by decision nodes, until and while condition and so on
      # to get real values in order to respect process execution semantics.
      #
      def evaluate(expression)
        raise "StatementExecution.evaluate should be implemented by subclasses"
      end
      
    end # class AbstractStatementExecution
    
  end # module Enactment
end # module CliPrEasy