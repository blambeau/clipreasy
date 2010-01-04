module CliPrEasy

  # Raised when CliPrEasy reaches an unexpected state situation
  class IllegalStateError < StandardError; end

  # Raised when CliPrEasy tend to violate some safety property
  class SafetyError < StandardError; end

  # Raised by the CliPrEasy::Config class when the configuration seems
  # buggy
  class ConfigError < StandardError; end
  
end # module CliPrEasy