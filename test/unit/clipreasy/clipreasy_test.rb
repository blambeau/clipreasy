require 'test/unit'
require 'clipreasy'
module CliPrEasy
  #
  # Provides a basic framework for handling safe tests that are able to 
  # support the different configuration modes of CliPrEasy
  #
  class CliPrEasyTest < Test::Unit::TestCase
    
    # Ensures that CliPrEasy is correctly loaded before running the test
    def setup
      CliPrEasy.start(@whoami_file)
      raise "Running tests is not allowed in production mode" if CliPrEasy.config.should_be_safe?
    end
    
    # Ensures that CliPrEasy is correctly loaded before running the test
    def teardown
      CliPrEasy.stop
    end
    
    # Tests that everything looks fine until now
    def test_empty
    end
    
  end # class CliPrEasyTest
end # module CliPrEasy