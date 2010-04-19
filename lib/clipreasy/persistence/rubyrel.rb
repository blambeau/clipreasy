module CliPrEasy
  module Persistence
    module Rubyrel
      
      # Returns the database schema 
      def self.schema
        ::Rubyrel::parse_ddl_file(File.join(File.dirname(__FILE__), 'rubyrel', 'schema', 'clipreasy.rel'))
      end
      
    end # module Rubyrel
  end # module Persistence
end # module CliPrEasy
require 'clipreasy/persistence/rubyrel/node'
#require 'clipreasy/persistence/rubyrel/activity'
#require 'clipreasy/persistence/rubyrel/decision'
#require 'clipreasy/persistence/rubyrel/parallel'
#require 'clipreasy/persistence/rubyrel/sequence'
#require 'clipreasy/persistence/rubyrel/until'
#require 'clipreasy/persistence/rubyrel/when'
#require 'clipreasy/persistence/rubyrel/while'
require 'clipreasy/persistence/rubyrel/process'