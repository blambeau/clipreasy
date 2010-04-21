module CliPrEasy
  module Enacter
    module ParallelExec
      
      # See Statement.start
      def execute
        started = statement.children.collect{|s| factor(s).start}.flatten
        if started.empty?
          close
        else
          started
        end
      end
      
      # See Statement.ended
      def ended(child)
        all_children_ended? ? close : []
      end
          
    end # module ParallelExec
  end # module Enacter
end # module CliPrEasy