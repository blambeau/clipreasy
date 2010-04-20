module CliPrEasy
  module Lang
    module When
      
      # Returns the clause
      def then
        children[0]
      end
      
      def inspect
        "upon(#{public_args_encoding}) { #{children_inspect} }; "
      end
      
    end # module When
  end # module Lang
end # module CliPrEasy