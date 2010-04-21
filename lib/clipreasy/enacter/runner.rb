module CliPrEasy
  module Enacter
    class Runner
      
      # Creates a runner instance
      def initialize(&block)
        @evaluator = block
      end
      
      # Delegates evaluations to the evaluator
      def evaluate(*args)
        @evaluator.call(*args)
      end
      
      # Starts a process execution
      def start(process, clazz = ::CliPrEasy::Enacter::InMemoryExec)
        process_exec = clazz.new(self, nil, process)
        terminals = process_exec.start
        [process_exec, terminals]
      end
      
    end # class Runner
  end # module Enacter
end # module CliPrEasy