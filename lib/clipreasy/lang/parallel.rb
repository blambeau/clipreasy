module CliPrEasy
  module Lang
    module Parallel
      
      def inspect
        "parallel(#{public_args_encoding}) { #{children_inspect} }; "
      end
      
    end # module Parallel
  end # module Lang
end # module CliPrEasy