module CliPrEasy
  
  # 
  # Provides CliPrEasy main configuration.
  #
  class Config
    
    # Path of the whoami file
    attr_accessor :whoami_file
    
    # Name of the installation
    attr_accessor :whoami
    
    # Mode of the installation (:devel, :test, :production)
    attr_accessor :mode
    
    # Connection information about the main database
    attr_accessor :database_info
    
    ###############################################################################################
    ### Creation and loading
    ###############################################################################################
    
    # Creates a configuration instance bounded to a whoami file
    def initialize(whoami_file)
      @whoami_file = whoami_file
    end
    
    # Creates a config instance by loading a configuration file from a whoami one
    def self.load(whoami_file)
      Config.new(whoami_file).load
    end
    
    # Loads the configuration from a given whoami file
    def load
      # 1) Read whoami_file and affect whoami instance variable
      raise ConfigError, "Missing whoami file (#{whoami_file})" unless File.exists?(whoami_file)
      self.whoami = File.read(whoami_file).strip
      raise ConfigError, "Invalid whoami (#{self.whoami})" unless /^[a-z0-9_]+$/ =~ self.whoami
      
      # 2) Find associated configuration file
      config_file = File.expand_path(File.join(File.dirname(whoami_file), "#{self.whoami}.config"))
      raise ConfigError, "Missing config file (#{config_file})" unless File.exists?(config_file)
      
      # 3) Execute the configuration file
      self.instance_eval File.read(config_file)
      
      # 4) check configuration now
      check_configuration
    rescue ConfigError => ex
      raise ex
    rescue => ex
      raise ConfigError, "Unexpected error occured when load CliPrEasy configuration", ex
    end
    
    # Checks the configuration, raises a ConfigError if something is wrong
    def check_configuration
      raise ConfigError, "Missing execution mode (:devel, :test, :production)" unless self.mode
      raise ConfigError, "Bad execution mode (#{self.mode})" unless [:devel, :test, :production].include?(self.mode)
      raise ConfigError, "Missing database information " unless self.database_info
      raise ConfigError, "Bad database information (#{self.database_info.inspect})" unless Hash===self.database_info 
      raise ConfigError, "Missing database adapter (#{self.database_info.inspect})" unless self.database_info[:adapter]
      raise ConfigError, "Missing database name (#{self.database_info.inspect})" unless self.database_info[:database]
      raise ConfigError, "Missing database host (#{self.database_info.inspect})" unless self.database_info[:host]
      raise ConfigError, "Missing database user (#{self.database_info.inspect})" unless self.database_info[:user]
      raise ConfigError, "Missing database password (#{self.database_info.inspect})" unless self.database_info[:password]
      self
    end
    
    ###############################################################################################
    ### Helpers
    ###############################################################################################
    
    # Returns true if the execution mode is :devel
    def devel?
      self.mode == :devel
    end
    
    # Returns true if the execution mode is :test
    def test?
      self.mode == :test
    end
    
    # Returns true if the execution mode is :production
    def production?
      self.mode == :production
    end
    
    # Checks if access control should be enabled for safety reasons
    def should_be_safe?
      self.production?
    end
    
  end # class Config
  
end # module CliPrEasy