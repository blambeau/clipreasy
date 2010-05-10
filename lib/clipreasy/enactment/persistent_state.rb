module CliPrEasy
  module Enactment
    class PersistentState
      
      # Statement under execution
      attr_reader :statement
      
      # Creates a new state instance
      def initialize(parent, statement, relvar, tuple, evaluator)
        @parent, @statement = parent, statement
        @relvar, @tuple = relvar, tuple
        @evaluator = evaluator
      end
      
      # Starts a new process execution
      def self.process_execution(relvar, process, evaluator = nil, &block)
        tuple = relvar << {
          :process_id   => process.identifier,
          :statement_id => nil,
          :parent_id    => nil,
          :status       => :pending,
          :started_at   => Time.now,
          :ended_at     => nil,
          :state        => {}
        }
        PersistentState.new(nil, process, relvar, tuple, evaluator || block)
      end
      
      # Checks if this scope is currently opened
      def pending?
        @tuple[:status] == :pending
      end
      
      # Branches this scope as a new child one
      def branch(statement)
        tuple = @relvar << {
          :process_id   => @tuple[:process_id],
          :statement_id => statement.identifier,
          :parent_id    => @tuple[:identifier],
          :status       => :pending,
          :started_at   => Time.now,
          :ended_at     => nil,
          :state        => {}
        }
        PersistentState.new(self, statement, @relvar, tuple, @evaluator)
      end
      
      # Returns the parent state 
      def parent
        @parent ||= load_parent
      end
      
      # Loads the parent state
      def load_parent
        return nil if @tuple[:parent_id].nil?
        tuple = @relvar.restrict(:identifier => @tuple[:parent_id]).tuple_extract
        PersistentState.new(@relvar, tuple, nil, @evaluator)
      end
      
      # Returns the value of a variable
      def get(variable)
        @tuple[:state][variable] || (parent && parent.get(variable))
      end
      
      # Sets the value of a given variable
      def set(variable, value)
        @tuple[:state][variable] = value
        @relvar.restrict(:identifier => @tuple[:identifier]).update(:state => @tuple[:state])
      end
      
      # Resume execution
      def resume
        statement.resume(self)
      end
    
      # Close this scope and returns its parent  
      def close
        updated = {:status => :ended, :ended_at => Time.now}
        @tuple = @tuple.merge(updated)
        @relvar.restrict(:identifier => @tuple[:identifier]).update(updated)
        parent
      end
      
      # Evaluates an expression
      def evaluate(expression)
        @evaluator.call(expression, self)
      end
      
    end # class PersistentState
  end # module Enactment
end # module CliPrEasy