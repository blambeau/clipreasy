require 'clipreasy/structural/entities2schema'
module CliPrEasy
  module Structural
    
    # Returns the pural form of an entity
    def self.plural_of(db, singular)
      db.structural.entities.restrict(:name => singular.to_s).tuple_extract.plural
    end
    
  end # module Structural
end # module CliPrEasy