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
      
      # Loads a process instance
      def load_process(db, process_id)
        tuples = db.model.processes.restrict(:identifier => process_id).to_a
        case tuples.size
          when 0
            raise ::CliPrEasy::UnknownProcessError, "Unknown process #{process_id}"
          when 1
            tuple = tuples.first
            ::CliPrEasy::Lang::Decoder.new(false).process(tuple.to_h) {|parent|
              load_process_statement(db, parent, tuple.identifier, tuple.main_id)
            }
          else
            raise "Unexpected case: more than one process tuple for #{process_id}"
        end
      end
      
      # Loads a process statement
      def load_process_statement(db, parent, process_id, identifier) 
        tuple = db.model.statements.restrict(:process_id => process_id, 
                                             :identifier => identifier).tuple_extract
        kind = tuple.kind
        call = kind.short_name.to_s.downcase.to_sym
        subtuple = db.model[MODEL_LANG_TO_RELVARS[kind]].restrict(:process_id => process_id, 
                                                                  :identifier => identifier).tuple_extract
        args = tuple.to_h.merge(subtuple.to_h)
        parent.send(call, args) {|new_parent|
          db.model.statements.restrict(:process_id => process_id, :parent_id => identifier).each {|t|
            load_process_statement(db, new_parent, process_id, t.identifier)
          }
        }
      end
      
      extend ::CliPrEasy::Persistence::Rubyrel
    end # module Rubyrel
  end # module Persistence
end # module CliPrEasy
require 'clipreasy/persistence/rubyrel/node'
require 'clipreasy/persistence/rubyrel/process'