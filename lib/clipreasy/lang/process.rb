module CliPrEasy
  module Lang
    module Process

      def inspect  
        "process(:#{identifier}) { #{ main.inspect } }; "
      end
      
    end # module Process
  end # module Lang
end # module CliPrEasy