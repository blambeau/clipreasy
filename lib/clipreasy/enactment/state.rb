module CliPrEasy
  module Enactment
    class State
      
      # Statement under execution
      attr_reader :statement
      
      # Creates a new scope instance
      def initialize(statement, parent = nil, evaluator = nil)
        raise ArgumentError, "Statement expected, #{statement} received"\
          unless ::CliPrEasy::Lang::Node === statement
        raise ArgumentError, "State expected for parent, #{parent} received"\
          unless parent.nil? or ::CliPrEasy::Enactment::State === parent
        @statement, @parent, @evaluator = statement, parent, evaluator 
        @state, @variables = :pending, {}
      end
      
      # Checks if this scope is currently opened
      def pending?
        @state == :pending
      end
      
      # Branches this scope as a new child one
      def branch(statement)
        State.new(statement, self, @evaluator)
      end
      
      # Returns the value of a variable
      def get(variable)
        @variables[variable] || (@parent && @parent.get(variable))
      end
      
      # Sets the value of a given variable
      def set(variable, value)
        @variables[variable] = value
      end
      
      # Resume execution
      def resume
        statement.resume(self)
      end
    
      # Close this scope and returns its parent  
      def close
        @state = :ended
        @parent
      end
      
      # Evaluates an expression
      def evaluate(expression)
        @evaluator.call(expression, self)
      end
      
    end # class State
  end # module Enactment
end # module CliPrEasy