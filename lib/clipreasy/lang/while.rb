module CliPrEasy
  module Lang
    module While
      
      # Returns the clause
      def then
        children[0]
      end
      
      def inspect
        "while_do('#{public_args_encoding}') { #{children_inspect} }; "
      end
      
    end # module While
  end # module Lang
end # module CliPrEasy