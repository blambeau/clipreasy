module CliPrEasy
  module Enacter
    module DecisionExec
      
      # See Statement.start
      def execute
        value = evaluate(statement.condition)
        
        # see clauses and start the good ones
        started = statement.children.collect do |clause|
          clause_value = evaluate(clause.value)
          value === clause_value ? factor(clause).start : nil
        end.flatten.compact
        
        started.empty? ? close : started
      end
            
      # See Statement.ended
      def ended(child)
        all_children_ended? ? close : []
      end
      
    end # module DecisionExec
  end # module Enacter
end # module CliPrEasy