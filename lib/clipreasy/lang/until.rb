module CliPrEasy
  module Lang
    module Until
      
      # Returns the clause
      def then
        children[0]
      end
      
      def inspect
        "until_do(#{public_args_encoding}) { #{children_inspect} }; "
      end
      
    end # module Until
  end # module Lang
end # module CliPrEasy