module CliPrEasy
  module Enactment
    module Memory
      # Implements AbstractStatementExecution for an in-memory execution
      class StatementExecution < ::CliPrEasy::Enactment::AbstractStatementExecution
        
        # Creates a process execution instance
        def initialize(factory, enacter, process_execution, parent, statement)
          @factory, @enacter, @process_execution = factory, enacter, process_execution
          @parent, @statement = parent, statement
          @children = []
          @status = :pending
        end
        
        ###################################################################################
        ### About execution link to process statements
        ###################################################################################
      
        # Returns the process statement attached to this statement execution
        def statement
          @statement
        end
      
        ###################################################################################
        ### About statement execution hierarchy
        ###################################################################################
      
        # Returns the parent execution
        def parent
          @parent || @process_execution
        end
      
        # Returns children executions, an empty array if no one
        def children
          @children
        end
      
        ###################################################################################
        ### About execution state
        ###################################################################################
      
        # Returns true if this execution is currently pending, false otherwise
        def pending?
          @status == :pending
        end
      
        # Returns true if this execution context is ended, false otherwise
        def ended?
          @status == :ended
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
          @factory.factor_statement_execution(@enacter, @process_execution, self, who)
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
          raise ::CliPrEasy::IllegalStateError, "Closing #{self} which is not pending" unless pending?
          @status = :ended
          @parent
        end
      
        #
        # Evaluates an expression that makes sense in the environment.
        #
        # This method is typically used by decision nodes, until and while condition and so on
        # to get real values in order to respect process execution semantics.
        #
        def evaluate(expression)
          @enacter.evaluate(expression)
        end
      
      end # class StatementExecution
    end # module Memory
  end # module Enactment
end # module CliPrEasy