module CliPrEasy
  module Enactment
    module Memory
      # Implements the ExecutionFactory contract for an in-memory execution
      class ExecutionFactory < ::CliPrEasy::Enactment::ExecutionFactory
        
        # Creates a ::CliPrEasy::Enactment::Memory::ProcessExecution instance
        def factor_process_execution(enacter, process, &block)
          exec = ::CliPrEasy::Enactment::Memory::ProcessExecution.new(enacter, process)
          block.call(exec) if block
          exec
        end
      
        # Creates a ::CliPrEasy::Enactment::Memory::StatementExecution instance
        def factor_statement_execution(enacter, process_execution, parent, statement, &block)
          exec = ::CliPrEasy::Enactment::Memory::StatementExecution.new(self, enacter, process_execution, parent, statement)
          block.call(exec) if block
          exec
        end
      
      end # class ProcessExecution
    end # module Memory
  end # module Enactment
end # module CliPrEasy