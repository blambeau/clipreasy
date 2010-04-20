module CliPrEasy
  module Lang
    module Activity
      
      # Inspects the node
      def inspect
        "activity(#{public_args_encoding})" << (children.empty? ? ";" : " { #{children_inspect} };")
      end
      
    end # module Activity
  end # module Lang
end # module CliPrEasy

