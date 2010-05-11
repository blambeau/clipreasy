module CliPrEasy

  # Raised when CliPrEasy reaches an unexpected state situation
  class IllegalStateError < StandardError; end

  # Raised when CliPrEasy tend to violate some safety property
  class SafetyError < StandardError; end

  # Raised by the CliPrEasy::Config class when the configuration seems
  # buggy
  class ConfigError < StandardError; end

  # Raised when some model refers to an entity which is unknown
  class UnknownEntityError < StandardError; end
  
  # Raised when some model refers to an entity attribute which is unknown
  class UnknownEntityAttributeError < StandardError; end
  
  # Raised when some model refers to a screen which is unknown
  class UnknownScreenError < StandardError; end
  
end # module CliPrEasy