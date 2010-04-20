module CliPrEasy
  module Lang
    class Node
      
      MAP_TO_RELVARS = {
        Activity => :activities,
        Decision => :decisions,
        When     => :decision_when_clauses,
        Parallel => :parallels,
        Sequence => :sequences,
        Until    => :untils,
        While    => :whiles
      }
      
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
            else
              nil
            end
          else 
            nil
          end
        end
        h
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