module CliPrEasy
  module Engine
    
    # 
    # Main level of statement hierarchy in process definitions, the Proces itself.
    #
    class Process < Statement
      
      #############################################################################################
      ### Instance variables
      #############################################################################################
      
      # Process identifier
      attr_accessor :id
      
      # Process human identifier
      attr_accessor :code
      
      # Process human identifier
      attr_accessor :label
      
      # Process human identifier
      attr_accessor :version
      
      # Process human identifier
      attr_accessor :description
      
      # Main statement
      attr_reader :main
      
      # Creates a workflow instance
      def initialize(main)
        @main = main
        main.parent = self
      end
      
      # Returns the main process, being self
      def process
        self
      end
      
      # Returns a statement by its token
      def statement(token)
        unless @statements
          @statements = {}
          depth_first_search do |s|
            @statements[s.statement_token] = s
          end
        end
        @statements[token]
      end
      
      # Recursively visits the process
      def depth_first_search(&block)
        yield self
        main.depth_first_search(&block)
      end
      
      # Inspects this process
      def inspect
        "#{self.class}::#{code}"
      end      
      
      #############################################################################################
      ### Process execution
      #############################################################################################
      
      # Starts the process with a given context
      def start(context)
        main.start(context)
      end
      
      # Fired by children when they are ended
      def ended(child, child_context)
        my_context = child_context.close
        my_context.close
        []
      end
      
    end # class Process

  end # module Engine
end # module CliPrEasy