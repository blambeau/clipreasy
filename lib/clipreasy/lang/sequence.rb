module CliPrEasy
  module Lang
    module Sequence 
      
      def inspect
        "sequence { #{children_inspect} }; "
      end
      
    end # module Sequence
  end # module Lang
end # module CliPrEasy