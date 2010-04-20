module CliPrEasy
  module Persistence
    module Rubyrel
      
      # Keeps track of relvar names for the different Lang nodes
      MODEL_LANG_TO_RELVARS = {
        CliPrEasy::Lang::Activity => :activities,
        CliPrEasy::Lang::Decision => :decisions,
        CliPrEasy::Lang::When     => :decision_when_clauses,
        CliPrEasy::Lang::Parallel => :parallels,
        CliPrEasy::Lang::Sequence => :sequences,
        CliPrEasy::Lang::Until    => :untils,
        CliPrEasy::Lang::While    => :whiles,
        CliPrEasy::Lang::Process  => :processes,
        CliPrEasy::Lang::Node     => :statements
      }
      
      # Returns the relvar to use for a given module
      def self.relvar_name_for(mod)
        MODEL_LANG_TO_RELVARS[mod]
      end
      
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