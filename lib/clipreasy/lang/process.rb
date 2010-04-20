module CliPrEasy
  module Lang
    module Process

      # Returns the process itself
      def process
        self
      end
      
      # Returns process children
      def children
        [main]
      end
      
      # Returns keys condidered private
      def private_arg_key?(key)
        [:main, :kind].include?(key)
      end
      
    end # module Process
  end # module Lang
end # module CliPrEasy