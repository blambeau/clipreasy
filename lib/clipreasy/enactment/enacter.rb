module CliPrEasy
  module Enactment
    # 
    # Provides a facade on the enactment logic of CliPrEasy
    #
    class Enacter
      
      # Factory for process and statement executions
      attr_reader :factory
      
      # Evaluator for expressions
      attr_reader :evaluator
      
      # Creates an enacter instance, with a process execution factory.
      def initialize(factory, &evaluator)
        @factory = factory
        @evaluator = evaluator
      end
      
      # Evaluates an expression 
      def evaluate(expression)
        @evaluator ? @evaluator.call(expression) : instance_eval(expression)
      end
      
      #
      # Starts the execution of a process. 
      #
      # Returns a pair [process_execution, [terminal_statement_execution1 ...]]
      # with execution instances of the process itelf as well as all pending
      # terminal statement executions.
      #
      def start_execution(process, &block)
        process_execution = @factory.factor_process_execution(self, process, &block)
        terminals = process.start(process_execution)
        [process_execution, terminals]
      end
      
    end # class Enacter
  end # module Enactment
end # module CliPrEasy