module CliPrEasy
  module Lang
    class Node
      
      # Generates a tuple for a given relation variable
      def to_relvar_tuple(relvar_def)
        h = {}
        relvar_def.attribute_names.each do |a|
          h[a] = if self.respond_to?(a)
            self.send(a)
          elsif /^(.*)_id$/ =~ a.to_s
            if self.respond_to?($1.to_sym)
              value = self.send($1.to_sym)
              value.nil? ? nil : value.identifier
            end
          end
        end
        h
      end
      
      # Saves this node into a relational model
      def save_on_relational_model(model, namespace)
        relvar_name = ::CliPrEasy::Persistence::Rubyrel::relvar_name_for(::CliPrEasy::Lang::Node)
        model[relvar_name] << to_relvar_tuple(namespace.relvar(relvar_name))
        relvar_name = ::CliPrEasy::Persistence::Rubyrel::relvar_name_for(kind)
        model[relvar_name] << to_relvar_tuple(namespace.relvar(relvar_name))
      end
      
      # Saves the schema on a rubyrel database
      def save_on_rubyrel_db(db)
        db.model.statements << to_relvar_tuple(db.model.statements.relvar_def)
        relvar = db.model.send(MAP_TO_RELVARS[kind])
        relvar << to_relvar_tuple(relvar.relvar_def)
      end
      
    end # class Node
  end # module Lang
end # module CliPrEasy