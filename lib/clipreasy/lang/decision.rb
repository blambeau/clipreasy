module CliPrEasy
  module Lang
    module Decision

      def inspect
        "decision('#{condition}') { #{children_inspect} }; "
      end

    end # module Decision
  end # module Lang
end # module CliPrEasy