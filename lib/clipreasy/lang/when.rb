module CliPrEasy
  module Lang
    module When
      
      # Returns the clause
      def then
        children[0]
      end
      
      def inspect
        "upon('#{value}') { #{children_inspect} }; "
      end
      
    end # module When
  end # module Lang
end # module CliPrEasy