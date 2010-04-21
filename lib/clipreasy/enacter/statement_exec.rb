module CliPrEasy
  module Enacter
    class StatementExec
      
      # Enacter
      attr_reader :enacter
      
      # Creates a statement execution for a given statement
      def initialize(enacter, parent, statement)
        @enacter = enacter
        extend(::CliPrEasy::Enacter.const_get("#{statement.kind.short_name}Exec".to_sym))
        install_internals(enacter, parent, statement)
      end
      
      # Install the internals
      def install_internals(enacter, parent, statement)
        raise NotImplementedError, "Subclass of StatementExec should implement install_internals"
      end
      
      # Returns the statement under execution
      def statement
        raise NotImplementedError, "Subclass of StatementExec should implement statement"
      end
      
      # Returns the process under execution
      def process
        statement.process
      end
      
      # Returns the parent statement
      def parent
        raise NotImplementedError, "Subclass of StatementExec should implement parent"
      end
      
      # Returns statement status
      def status
        raise NotImplementedError, "Subclass of StatementExec should implement status"
      end
      
      # Returns statement children
      def children
        raise NotImplementedError, "Subclass of StatementExec should implement children"
      end
      
      # Returns true if this execution is ended, false otherwise
      def ended?
        status == :ended
      end
      
      # Checks if all children statement are ended
      def all_children_ended?
        children.all?{|c| c.ended?}
      end
      
      # Returns true if this execution is pending, false otherwise
      def pending?
        status == :started
      end
      
      # Factors a StatementExec for a given statement
      def factor(statement)
        raise NotImplementedError, "Subclass of StatementExec should implement factor"
      end
      
      # Evaluates an expression
      def evaluate(expression)
        @enacter.evaluate(expression)
      end
      
      # Starts this execution
      def start
        execute
      end
      
      # Closes this statement execution
      def close
        parent ? parent.ended(self) : []
      end
      
      # Returns a string representation
      def to_s
        "Execution of #{statement.to_s}"
      end
      alias :inspect :to_s
      
    end # class StatementExec
  end # module Enacter
end # module CliPrEasy
