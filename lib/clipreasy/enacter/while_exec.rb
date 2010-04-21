module CliPrEasy
  module Enacter
    module WhileExec
      
      def execute
        evaluate(statement.condition) ? factor(statement.then).start : close
      end
            
      def ended(child)
        evaluate(statement.condition) ? factor(statement.then).start : close
      end
      
    end # module WhileExec
  end # module Enacter
end # module CliPrEasy