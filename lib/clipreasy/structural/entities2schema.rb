module CliPrEasy
  module Structural
    class Entities2Schema
      
      # The Underlying database instance
      attr_reader :database
      
      # Creates an converter instance based on a database
      def initialize(database)
        @database = database
      end
      
      # Finds all weak attributes of an entity whose tuple is given
      def weak_attributes(entity_tuple)
        return [] unless entity_tuple.weak_of
        entities = database.structural.entities.restrict(:name => entity_tuple.weak_of.to_s)
        [entity_tuple.weak_of] + weak_attributes(entities.tuple_extract)
      end
      
      # Generates a Ruby schema 
      def generate_schema(name = "", namespace = "default")
        # Create a schema and a namespace
        schema = ::Rubyrel::DDL::Schema.new(name)
        namespace = schema.namespace(namespace, true)
        
        # One relvar for each entity
        created_relvars = {}
        database.structural.entities.each do |entity_tuple|
          relvar = namespace.relvar(entity_tuple.plural, true)
          
          # Relvar attributes now...
          database.structural.entity_attributes.
            restrict(:entity => entity_tuple.name.to_s).each do |attr_tuple|
            relvar.add_attribute(attr_tuple.name, attr_tuple.domain)
          end

          # Primary key and weak_of attributes
          weak_attrs = weak_attributes(entity_tuple)
          relvar.add_attribute(:token, Integer, {:default => ::Rubyrel::Defaults::Autonumber.new})
          relvar.set_primary_key(relvar.add_candidate_key("#{entity_tuple.name}", relvar.attributes(:token)))

          created_relvars[entity_tuple.name] = relvar
        end
        
        # Install foreign keys now
        # database.structural.entities.each do |entity_tuple|
        #   next unless entity_tuple.weak_of
        #   relvar = namespace.relvar(entity_tuple.plural, false)
        #   target = created_relvars[entity_tuple.weak_of]
        #   relvar.add_foreign_key("fr_#{entity_tuple.plural}__refs__#{entity_tuple.weak_of}",
        #                          relvar.attributes(entity_tuple.weak_of),
        #                          target.primary_key)
        # end
        
        # Returns the schema
        schema
      end
      
    end # module Entities2Structural
  end # module Structural
end # module CliPrEasy