module CliPrEasy
  module Enactment

    #
    # Parallel statement inside a process definition.
    #
    module Parallel
      
      # See Statement.start
      def start(parent_exec)
        #puts "Starting parallel #{self.business_id}"
        my_exec = parent_exec.started(self)
        started = children.collect {|s| s.start(my_exec)}.flatten
        if started.empty?
          parent_in_execution.ended(self, my_exec)
        else
          started
        end
      end
      
      # See Statement.ended
      def ended(child, child_exec)
        my_exec = child_exec.close
        #puts "Parallel.ended(#{my_exec.all_children_ended?})"
        my_exec.all_children_ended? ? parent_in_execution.ended(self, my_exec) : []
      end
          
    end # module Parallel
    
  end # module Enactment
end # module CliPrEasy