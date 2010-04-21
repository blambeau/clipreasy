module CliPrEasy
  module Enacter
    
    # Builds a basic enacter instance
    def enacter(&block)
      ::CliPrEasy::Enacter::Runner.new(&block)
    end
    module_function :enacter
    
    # Builds a basic enacter instance
    def run(process, &block)
      enacter(&block).start(process)
    end
    module_function :run
    
  end # module Enacter
end # module CliPrEasy
require 'clipreasy/enacter/statement_exec'
require 'clipreasy/enacter/activity_exec'
require 'clipreasy/enacter/decision_exec'
require 'clipreasy/enacter/parallel_exec'
require 'clipreasy/enacter/process_exec'
require 'clipreasy/enacter/sequence_exec'
require 'clipreasy/enacter/until_exec'
require 'clipreasy/enacter/while_exec'
require 'clipreasy/enacter/when_exec'
require 'clipreasy/enacter/in_memory_exec'
require 'clipreasy/enacter/runner'
