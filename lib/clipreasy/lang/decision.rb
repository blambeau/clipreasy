module CliPrEasy
  module Lang
    module Decision

      def inspect
        "decision(#{public_args_encoding}) { #{children_inspect} }; "
      end

    end # module Decision
  end # module Lang
end # module CliPrEasy