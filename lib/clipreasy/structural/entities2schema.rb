module CliPrEasy
  module Structural
    class Entities2Schema
      
      # The Underlying database instance
      attr_reader :database
      
      # Creates an converter instance based on a database
      def initialize(database)
        @database = database
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
          
          # Primary key and weak_of attribute
          relvar.add_attribute(:pkey, Integer, {:default => ::Rubyrel::Defaults::Autonumber.new})
          relvar.set_primary_key(relvar.add_candidate_key("#{entity_tuple.name}", relvar.attributes(:pkey)))
          relvar.add_attribute(entity_tuple.weak_of, Integer) if entity_tuple.weak_of
          
          # Relvar attributes now...
          database.structural.entity_attributes.
            restrict(:entity => entity_tuple.name.to_s).each do |attr_tuple|
            relvar.add_attribute(attr_tuple.name, attr_tuple.domain)
          end

          created_relvars[entity_tuple.name] = relvar
        end
        
        # Install foreign keys now
        database.structural.entities.each do |entity_tuple|
          next unless entity_tuple.weak_of
          relvar = namespace.relvar(entity_tuple.plural, false)
          target = created_relvars[entity_tuple.weak_of]
          relvar.add_foreign_key("fr_#{entity_tuple.plural}__refs__#{entity_tuple.weak_of}",
                                 relvar.attributes(entity_tuple.weak_of),
                                 target.primary_key)
        end
        
        # Returns the schema
        schema
      end
      
    end # module Entities2Structural
  end # module Structural
end # module CliPrEasy