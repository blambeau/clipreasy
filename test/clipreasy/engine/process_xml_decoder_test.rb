require 'clipreasy'
require 'test/unit'
module CliPrEasy
  module Engine
    class ProcessXMLDecoderTest < Test::Unit::TestCase
      
      def relative_file(path)
        File.join(File.dirname(__FILE__), path)
      end
      
      def test_structure_on_example_1
        process = ProcessXMLDecoder.decode_file(relative_file('example_1.cpe'))
        assert Process===process
        assert_equal "work_and_cofee", process.id

          main = process.main
          assert Sequence===main
          assert_equal 3, main.size
          go, par, leave = main.statements
        
            assert Activity===go
            assert_equal "go_to_work_place", go.id

            assert Parallel===par
            assert_equal 2, par.size
            work, drink = par.statements
              
              assert Activity===work
              assert_equal "work", work.id

              assert Activity===drink
              assert_equal "drink_coffee", drink.id

            assert Activity===leave
            assert_equal "leave_work_place", leave.id
            
        assert_nil process.parent
        assert_equal process, process.process

        assert_equal process, main.parent
        assert_equal process, main.process

        assert_equal main, go.parent
        assert_equal process, go.process
        assert_equal main, par.parent
        assert_equal process, par.process
        assert_equal main, leave.parent
        assert_equal process, leave.process
        
        assert_equal par, work.parent
        assert_equal process, work.process
        assert_equal par, drink.parent
        assert_equal process, drink.process
        
        tokens = []
        process.depth_first_search{|s| tokens << s.statement_token}
        assert_equal 7, tokens.size
        assert_equal [0, 1, 2, 3, 4, 5, 6], tokens
        assert process==process.statement(0)
      end
      
      def test_activities_on_example_1
        process = ProcessXMLDecoder.decode_file(relative_file('example_1.cpe'))
        activities = process.activities
        assert_equal 4, activities.size
        assert_equal ["go_to_work_place", "work", "drink_coffee", "leave_work_place"], activities.collect{|act| act.id}
        
        assert_equal 4, process.main.activities.size
        assert_equal ["go_to_work_place", "work", "drink_coffee", "leave_work_place"], process.main.activities.collect{|act| act.id}
        
        par = process.main[1]
        assert_equal 2, par.activities.size
        assert_equal ["work", "drink_coffee"], par.activities.collect{|act| act.id}
      end
      
      def test_depth_first_search
        process = ProcessXMLDecoder.decode_file(relative_file('example_1.cpe'))
        main = process.main
        go, par, leave = main.statements
        work, drink = par.statements
        expected = [process, main, go, par, work, drink, leave]
        seen = []
        process.depth_first_search {|s| seen << s}
        assert_equal expected, seen
      end

      
    end # class ProcessXMLDecoderTest
  end # module Engine
end # module CliPrEasy
    