module CliPrEasy
  module Enactment
    # 
    # Main level of statement hierarchy in process definitions, the Process itself.
    #
    module Process
      
      #
      # Starts the execution of this process inside a given process execution
      # instance (see AbstractProcessExecution) passed as argument.
      #
      # This method basically starts the execution of the main process statement.
      #
      def start(process_execution)
        main.start(process_execution)
      end
      
      #
      # Fired when the execution of a child ends (the main statement, in this case). 
      #
      # This methods ends the process execution itself.
      #
      def ended(child, child_execution)
        my_exec = child_execution.close
        my_exec.close
        []
      end
      
    end # module Process
  end # module Enactment
end # module CliPrEasy