module CliPrEasy
  module Lang
    module Process
      include Enumerable

      # Returns the process itself
      def process
        self
      end
      
      # Returns process children
      def children
        [main]
      end
      
      # Lauches a dfs on the main statement
      def each(&block)
        main.dfs(&block)
      end
      
      # Returns keys condidered private
      def private_arg_key?(key)
        [:main, :kind].include?(key)
      end
      
    end # module Process
  end # module Lang
end # module CliPrEasy