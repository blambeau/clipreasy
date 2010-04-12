module CliPrEasy
  module Model
    
    #
    # Activity inside a process.
    #
    # An Activity is the lower level in statement abstractions. It provides
    # a basic unit of work, typically made by only one actor. 
    #
    class Activity < Statement
      
      # Activity's label 
      attr_accessor :label

      # See Statement.depth_first_search
      def depth_first_search(&block)
        raise ArgumentError, "Missing block in depth_first_search" unless block
        yield(self)
      end
      
    end # class Activity
  end # module Model
end # module CliPrEasy