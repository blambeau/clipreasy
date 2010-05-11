module CliPrEasy
  module Structural
    class ActiveTuple
      
      # Creates an active tuple instance
      def initialize(engine, entity_name, token)
        @engine, @entity_name, @token = engine, entity_name, token
        __install
      end
      
      # Returns the underlying base relation variable
      def __relvar
        @engine.model_namespace.relvar(@engine.plural_of(@entity_name), false)
      end
      
      # Loads the tuple from the database
      def __tuple
        @__tuple || __relvar.restrict(:token => @token).tuple_extract
      end
      
      # Returns tuple's token
      def token
        __tuple.token
      end
      
      # Installs this active tuple
      def __install
        self.instance_eval <<-EOF
          def #{@entity_name}
            self
          end
        EOF
        @engine.entity_attributes(@entity_name).each do |attr_tuple|
          if attr_tuple.references
            self.instance_eval <<-EOF
              def #{attr_tuple.name}
                __#{attr_tuple.name} ||= ActiveTuple.new(@engine, :#{attr_tuple.references}, __tuple[:#{attr_tuple.name}])
              end
            EOF
          else
            self.instance_eval <<-EOF
              def #{attr_tuple.name}
                __tuple[:#{attr_tuple.name}]
              end
            EOF
          end
        end
      end
      
      # Lookup method
      def [](name)
        self.instance_eval name.to_s
      end
      
    end # class ActiveTuple
  end # module Structural
end # module CliPrEasy