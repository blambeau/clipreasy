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
      def relvar_name_for(mod)
        MODEL_LANG_TO_RELVARS[mod]
      end
      
      # Returns a path to the clipreasy schema file
      def schema_file
        File.join(File.dirname(__FILE__), 'rubyrel', 'schema', 'clipreasy.rel')
      end
      
      # Returns the database schema 
      def schema
        ::Rubyrel::parse_ddl_file(schema_file)
      end
      
      # Installs the database schema on a sequel handler
      def install_schema!(handler)
        ::Rubyrel::create_db(schema_file, handler, {:verbose => false})
      end
      
      extend ::CliPrEasy::Persistence::Rubyrel
    end # module Rubyrel
  end # module Persistence
end # module CliPrEasy
require 'clipreasy/persistence/rubyrel/node'
require 'clipreasy/persistence/rubyrel/process'