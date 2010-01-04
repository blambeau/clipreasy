require 'clipreasy'
require 'test/unit'
module CliPrEasy
  module State
    class RelationTest < Test::Unit::TestCase
      
      def test_it_correctly_serves_tuples
        dataset = [
          {:lname => "Lambeau", :fname => "Bernard"},  
          {:lname => "Coevoet", :fname => "Maxime"},  
        ]
        relation = Relation.new(dataset)
        assert_equal dataset, relation.dataset
        relation.each_with_index do |tuple, index|
          assert Tuple===tuple
          assert_equal (index==0 ? "Lambeau" : "Coevoet"), tuple.lname
        end
      end
      
    end
  end
end # module CliPrEasy