module CliPrEasy
  module Enacter
    module WhenExec
      
      def execute
        factor(statement.then).start
      end
            
      def ended(child)
        close
      end
      
    end # module WhenExec
  end # module Enacter
end # module CliPrEasy