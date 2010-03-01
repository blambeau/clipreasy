require 'clipreasy'
require 'clipreasy/clipreasy_test'
module CliPrEasy
  module Engine
    class ProcessPredicatesTest < CliPrEasy::CliPrEasyTest
      
      def relative_file(path)
        File.join(File.dirname(__FILE__), path)
      end
      
      def test_it_loads_predicates_correctly
        process = ProcessXMLDecoder.decode_file(relative_file('example_2.cpe'))
        assert_not_nil process.folder
        evaluator = process.evaluator(1)
        assert evaluator.respond_to?(:too_much?)
      end
      
    end
  end
end
