require 'rubygems'
require 'sequel'

#
# Main module of Clinical Process Made Easy
#
module CliPrEasy
  
  # Current version
  VERSION = "0.1.0".freeze
  
end

require 'clipreasy/errors'
require 'clipreasy/model'
require 'clipreasy/enactment'
require 'clipreasy/persistence'
