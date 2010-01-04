module CliPrEasy
  module Engine
    
    #
    # Implements ProcessContext for situation where the process state cannot fit in memory.
    #
    class BackendProcessContext < ProcessContext
      
      #
      # Provides the Backend companion of BackendProcessContext
      #
      class Backend
        
        # Checks if some attributes can be interpreted as a pending statement
        def pending?(attributes)
          raise "Backend.pending? should be implemented by subclasses"
        end
        
        # Checks if some attributes can be interpreted as an ended statement
        def ended?(attributes)
          raise "Backend.ended? should be implemented by subclasses"
        end
        
        # Returns the parent attributes of some attributes.
        def parent_of(attributes)
          raise "Backend.parent_of should be implemented by subclasses"
        end
        
        # Returns the children attributes of some attributes.
        def children_of(attributes)
          raise "Backend.children_of should be implemented by subclasses"
        end
        
        # Branches some statement _who_ and returns new attributes for it
        def branch(attributes, who, *args)
          raise "Backend.branch should be implemented by subclasses"
        end
        
        # Close some statement from attributes and associated statement
        def close(attributes, statement)
          raise "Backend.close should be implemented by subclasses"
        end
        
        # Evaluates an expression
        def evaluate(expression)
          raise "Backend.evaluate should be implemented by subclasses"
        end
        
      end # class Backend
      
      # Creates a process context with a given backend, statement and attached attributes
      def initialize(backend, statement, attributes)
        raise ArgumentError if backend.nil? or statement.nil? or attributes.nil?
        @backend, @statement, @attributes = backend, statement, attributes
      end
      
      ###################################################################################
      ### About execution context link to process statements
      ###################################################################################
      
      # Returns the process statement attached to this execution context
      def statement
        @statement
      end
      
      ###################################################################################
      ### About execution context hierarchy
      ###################################################################################
      
      # Returns the parent execution context
      def parent
        return nil if CliPrEasy::Engine::Process === @statement
        return @parent if @parent
        if (parent_attrs = @backend.parent_of(@attributes))
          @parent = BackendProcessContext.new(@backend, 
                                              @statement.parent, 
                                              parent_attrs)
        else
          raise IllegalStateError, "Parent attributes expected for #{@attributes.inspect}"
        end
      end
      
      # Returns children execution contexts, an empty array if no one
      def children
        @children ||= backend.children_of(@attributes).collect do |child_attrs|
          BackendProcessContext.new(@backend, self, child_attrs)
        end 
      end
      
      ###################################################################################
      ### About execution context state
      ###################################################################################
      
      # Returns true if this execution context is currently pending, false otherwise
      def pending?
        @backend.pending?(@attributes)
      end
      
      # Returns true if this execution context is ended, false otherwise
      def ended?
        @backend.ended?(@attributes)
      end
      
      # Checks if all children execution context are ended
      # This method is implemented by default through the children accesssor but may
      # be overriden for better strategies.
      def all_children_ended?
        @backend.children_of(@attributes).all?{|c| @backend.ended?(c)}
      end
      
      ###################################################################################
      ### About execution itself
      ###################################################################################
      
      #
      # Fired when a statement _who_ is started. 
      #
      # By construction, _who_ is always a child of the attached statement (pre-condition
      # not checked). Optional arguments may be passed by specific statements, see their
      # documentation for details.
      #
      # This method is expected to branch the execution context to provide a children 
      # context for _who_'s execution. This execution context child MUST be returned by
      # the method and provided in _children_ later.
      #
      # This method is not intended to be invoked outside the process framework itself
      # (that is, by Statement subclasses).
      #
      def started(who, *args)
        @children = nil
        new_attrs = @backend.branch(@attributes, who, *args)
        BackendProcessContext.new(@backend, who, new_attrs)
      end
      
      #
      # Closes this execution context and returns its parent.
      #
      # This execution context should be currently pending, strange behavior could occur
      # otherwise. After invocation, the execution context is expected to be ended.
      #
      # This method is not intended to be invoked outside the process framework itself
      # (that is, by Statement subclasses).
      #
      def close
        @backend.close(@attributes, @statement)
        parent
      end
      
      #
      # Evaluates an expression that makes sense in the environment.
      #
      # This method is typically used by decision nodes, until and while condition and so on
      # to get real values in order to respect process execution semantics.
      #
      def evaluate(expression)
        @backend.evaluate(expression)
      end
      
      # Inspects this execution context
      def inspect
        "#{statement.inspect} #{@attributes.inspect}"
      end
      
    end # class BackendProcessContext
    
  end # module Engine
end # module CliPrEasy