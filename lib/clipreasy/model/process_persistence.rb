module CliPrEasy
  module Engine
    class Statement
      
      # Provides a tuple that matches the database structure
      def to_statement_tuple
        {:process     => self.process.id,
         :lid         => statement_token,
         :parent      => self.parent.statement_token,
         :kind        => self.class.to_s,
         :code        => (self.respond_to?(:code) ?  self.code  : ''),
         :label       => (self.respond_to?(:label) ? self.label : ''),
         :color       => (self.respond_to?(:color) ? self.color : ''),
         :description => (self.respond_to?(:description) ? self.description : ''),
         :sort_by     => statement_token}
      end
      
    end # class Statement
    class Process < Statement
      
      # Returns a process instance matched by code or id
      def self.[](id)
        load_from_database(id)
      end
      
      # Loads a process from a database
      def self.load_from_database(id)
        processes = CliPrEasy::DAS.dataset(:processes)
        tuple = processes.filter(:id => id).first if /^\d+$/ =~ id.to_s
        tuple = processes.filter(:code => id).order(:version.desc).first unless tuple
        return nil unless tuple
        process = CliPrEasy::Engine::ProcessXMLDecoder.decode(tuple[:formaldef])
        process.id = id
        process
      end
      
      # Provides a tuple that matches the database structure
      def to_process_tuple
        {:code        => self.code,
         :label       => self.label,
         :version     => self.version,
         :description => self.description,
         :formaldef   => self.formaldef,
         :folder      => (self.folder || '')}
      end
      
      # Saves the process to the database
      def save_to_database(db = nil)
        if db
          self.id = (db[:processes].insert(self.to_process_tuple))
          depth_first_search do |statement|
            db[:statements].insert(statement.to_statement_tuple)
          end
        else
          CliPrEasy::DAS.transaction do |t|
            self.id = (t.processes.insert(self.to_process_tuple))
            depth_first_search do |statement|
              t.statements.insert(statement.to_statement_tuple)
            end
          end
        end
      end
      
    end # class Process
  end # module Engine
end # module CliPrEasy