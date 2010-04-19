module CliPrEasy
  module Lang
    module Until
      
      # Returns the clause
      def then
        children[0]
      end
      
      def inspect
        "until_do('#{condition}') { #{children_inspect} }; "
      end
      
    end # module Until
  end # module Lang
end # module CliPrEasy