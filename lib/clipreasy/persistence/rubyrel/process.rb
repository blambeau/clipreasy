module CliPrEasy
  module Lang
    module Process
      
      # Returns the process itself
      def process
        self
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