module CliPrEasy
  module Lang
    module Process
      
      # Returns the process itself
      def process
        self
      end
      
      # Returns the process encoded as a set of relations
      def to_relational
        relvar_names = CliPrEasy::Persistence::Rubyrel::MODEL_LANG_TO_RELVARS.values
        schema = Struct.new(*relvar_names)
        model = schema.new(*Array.new(relvar_names.size){|i| Array.new})
        def model.inspect
          self.class.members.collect{|r|
            "--- #{r} ---\n" << self[r].collect{|h| h.inspect}.join("\n")
          }.join("\n")
        end
        save_on_relational_model(model)
      end
    
      # Saves the process on a relational model
      def save_on_relational_model(model, schema = ::CliPrEasy::Persistence::Rubyrel::schema.namespace(:model))
        relvar_name = ::CliPrEasy::Persistence::Rubyrel::relvar_name_for(kind)
        model[relvar_name] << to_relvar_tuple(schema.relvar(relvar_name))
        main.dfs{|s|
          s.save_on_relational_model(model, schema)
        } if main
        model
      end
    
      # Saves the schema on a rubyrel database
      def save_on_rubyrel_db(db)
        db.transaction do |t|
          t.model.processes << to_relvar_tuple(t.model.processes.relvar_def)
          main.dfs{|s|
            s.save_on_rubyrel_db(t) 
          } if main
        end
      end
      
    end # module Process
  end # module Lang
end # module CliPrEasy