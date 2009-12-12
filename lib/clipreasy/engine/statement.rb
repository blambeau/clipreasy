module CliPrEasy
  module Engine

    #
    # Abstract statement inside a process
    #
    class Statement
      include Markable
      
      # Unique token for this statement
      attr_accessor :statement_token
      
      # Parent statement, or the process itself
      attr_reader :id
      
      # Parent statement, or the process itself
      attr_accessor :parent
      
      #
      # Returns the main process, top level of the hierarchy.
      #
      def process
        @process ||= parent.process
      end
      
      #
      # Finds all activities being descendants of this statement.
      #
      # This method relies on depth_first_search that must be implemented by
      # subclasses
      #
      def activities
        result = []
        depth_first_search do |elm|
          result << elm if Activity===elm
        end
        result
      end

      #      
      # Finds an descendant activity by its id. Returns nil if no such
      # activity can be found.
      #
      def activity(id)
        activities.select{|a| a.id==code}.first
      end
      
      #
      # Starts the statement inside an execution context. Returns terminal execution contexts
      # that have been started due to this start.
      #
      # This method MUST be implemented bu sublasses and raises an exception 
      # by default.
      #
      def start(context)
        raise "start MUST by implemented by Engine::Statement subclasses (#{self.class} was missing)"
      end
      
      #
      # Fired by children when they are ended. Returns terminal execution contexts
      # that have been started due to this end.
      #
      def ended(child, child_context)
        raise "ended MUST by implemented by Engine::Statement subclasses (#{self.class} was missing)"
      end
          
      # 
      # Inspects this statement
      #  
      def inspect
        self.class.name =~ /::([a-zA-Z0-9]+)$/
        @id ? "#{$1}:#{id}" : "#{$1}"
      end      
      
    end # class Statement

  end # module Engine
end # module CliPrEasy
