require 'test/unit'
require 'clipreasy/errors'
require 'clipreasy/config'
module CliPrEasy
  class ConfigTest < Test::Unit::TestCase
    
    def relative_file(rel)
      File.join(File.dirname(__FILE__), rel)
    end
    
    def test_on_valid_file
      file = relative_file('config_files/valid.whoami')
      config = Config.load(file)
      assert Config===config
      assert_equal :devel, config.mode
    end
    
    def test_on_missing_mode
      file = relative_file('config_files/missing_mode.whoami')
      assert_raise ConfigError do
        config = Config.load(file)
      end
    end
    
  end
end