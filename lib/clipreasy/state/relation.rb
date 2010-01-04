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
      
    end # class Relation
  end # module State
end # module CliPrEasy