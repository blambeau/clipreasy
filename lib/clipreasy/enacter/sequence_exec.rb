module CliPrEasy
  module Enacter
    module SequenceExec
      
      # See Statement.start
      def execute
        factor(statement.children.first).start
      end
      
      # See Statement.ended
      def ended(child)
        child_st, children_st = child.statement, statement.children
        if child_st == children_st.last
          close
        else
          factor(children_st[children_st.index(child_st)+1]).start
        end
      end
          
    end # module SequenceExec
  end # module Enacter
end # module CliPrEasy