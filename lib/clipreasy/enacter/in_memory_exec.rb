module CliPrEasy
  module Enacter
    class InMemoryExec < StatementExec

      # Install the internals
      def install_internals(enacter, parent, statement)
        parent.children << self if parent
        @parent, @statement, @status, @children = parent, statement, :created, []
      end
      
      # Returns the statement under execution
      def statement
        @statement
      end
      
      # Returns the parent statement
      def parent
        @parent
      end
      
      # Returns statement status
      def status
        @status
      end
      
      # Returns statement children
      def children
        @children
      end
      
      # Factors a StatementExec for a given statement
      def factor(statement)
        InMemoryExec.new(@enacter, self, statement)
      end

      # Starts this execution
      def start
        @status = :started
        super
      end
      
      # Closes this statement execution
      def close
        @status = :ended
        parent ? parent.ended(self) : []
      end

    end # class InMemoryExec
  end # module Enacter
end # module CliPrEasy
