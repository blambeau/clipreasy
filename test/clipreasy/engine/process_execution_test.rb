require 'clipreasy'
require 'test/unit'
module CliPrEasy
  module Engine
    class ProcessExecutionTest < Test::Unit::TestCase
      
      def relative_file(path)
        File.join(File.dirname(__FILE__), path)
      end
      
      def test_on_example_1
        process = ProcessXMLDecoder.decode_file(relative_file('example_1.cpe'))
        context = process.start
        assert ProcessContext===context
        assert Activity===context.statement
        context = context.activity_ended
        assert Array===context
        assert_equal 2, context.size
        
        last = nil
        context.each do |ctx|
          assert ProcessContext===ctx
          last = ctx.activity_ended
        end
        
        assert ProcessContext===last
        last = last.activity_ended
        
        assert nil===last
      end
      
    end # class ProcessExecutionTest
  end # module Engine
end # module CliPrEasy
      