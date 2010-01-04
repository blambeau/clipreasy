require 'clipreasy'
require 'test/unit'
module CliPrEasy
  module State
    class TupleTest < Test::Unit::TestCase
      
      def test_it_decorates_hash_correctly
        hash = {:thekey => "thevalue", :thecount => 0}
        tuple = Tuple.new(hash)
        assert_equal "thevalue", tuple.thekey
        assert_equal 0, tuple.thecount
        tuple.thekey = "hello"
        assert_equal "hello", tuple.thekey
      end
      
      def test_it_recognizes_invalid_hashes
        hash = {0 => "hello0"}
        assert_raise ArgumentError do
          Tuple.new(hash)
        end
        hash = {"hello" => "hello0"}
        assert_raise ArgumentError do
          Tuple.new(hash)
        end
      end
      
    end
  end
end