module CliPrEasy
  module State
    #
    # Decorates a Sequel DataSet with powerful relation abstractions
    #
    class Relation
      include Enumerable
     
      # Decorated dataset
      attr_reader :dataset
      
      # Creates a relation instance
      def initialize(dataset)
        @dataset = dataset
      end
      
      # Decorates Sequel dataset records (Hash instances) as CliPrEasy 
      # Tuple instances. 
      def each
        dataset.each {|hash| Tuple.new(hash)}
      end
      
      # Inserts some tuples inside the relation
      def <<(tuples)
        case tuples
          when Hash
            @dataset.insert(tuples)
          when Array
            tuples.each {|t| @dataset.insert(t)}
          else
            raise ArgumentError, "Invalid tuples #{tuples}"
        end
      end
      
    end # class Relation
  end # module State
end # module CliPrEasy