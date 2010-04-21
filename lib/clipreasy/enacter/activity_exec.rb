module CliPrEasy
  module Enacter
    module ActivityExec

      # See Statement.start
      def execute
        [self]
      end
      
      # See Statement.ended
      def ended(child)
        raise NotImplementedError
      end
      
    end # module Activity
  end # module Enactment
end # module CliPrEasy