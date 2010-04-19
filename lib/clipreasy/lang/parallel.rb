module CliPrEasy
  module Lang
    module Parallel
      
      def inspect
        "parallel { #{children_inspect} }; "
      end
      
    end # module Parallel
  end # module Lang
end # module CliPrEasy