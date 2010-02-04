module CliPrEasy
  module Model
    
    # 
    # Main level of statement hierarchy in process definitions, the Process itself.
    #
    class Process < Statement
      include Enumerable
      
      # Main statement
      attr_reader :main
      
      # Creates a workflow instance
      def initialize(main)
        raise ArgumentError, "Missing main statement in Process" unless Statement===main
        @main = main
        self.parent = nil
        main.parent = self
        each_with_index{|s, i| s.identifier = i}
      end
      
      # Returns the main process, being self
      def process
        self
      end
      
      # Returns a Hash mapping business ids to statements
      def map_by_identifier
        @statement_by_id = inject({}){|memo,s| memo[s.identifier] = s; memo} unless @statement_by_id
        @statement_by_id
      end
      
      # Returns a statement by its identifier
      def statement_by_identifier(identifier)
        map_by_identifier[identifier]
      end
      
      # Returns a Hash mapping business ids to statements
      def map_by_business_id
        @statement_by_business_id = inject({}){|memo,s| memo[s.business_id] = s if s.business_id; memo}\
           unless @statement_by_business_id
        @statement_by_business_id
      end
      
      # Returns a statement by its business_id
      def statement_by_business_id(business_id)
        map_by_business_id[business_id]
      end
      
      # See Statement.depth_first_search
      def depth_first_search(&block)
        raise ArgumentError, "Missing block in depth_first_search" unless block
        yield(self)
        main.depth_first_search(&block)
      end
      alias :each :depth_first_search
      
      # Inspects this process
      def inspect
        "#{self.class}::#{business_id}"
      end      
      
    end # class Process

  end # module Model
end # module CliPrEasy