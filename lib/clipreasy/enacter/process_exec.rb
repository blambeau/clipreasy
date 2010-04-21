module CliPrEasy
  module Enacter
    module ProcessExec
      
      def execute
        factor(statement.main).start
      end
      
      def ended(child)
        close
      end
      
    end # module ProcessExec
  end # module Enactment
end # module CliPrEasy