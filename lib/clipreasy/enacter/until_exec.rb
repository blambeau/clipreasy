module CliPrEasy
  module Enacter
    module UntilExec
      
      def execute
        evaluate(statement.condition) ? close : factor(statement.then).start
      end
            
      def ended(child)
        evaluate(statement.condition) ? close : factor(statement.then).start
      end
      
    end # module UntilExec
  end # module Enacter
end # module CliPrEasy