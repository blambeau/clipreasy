module CliPrEasy
  class Engine
    
    # The underlying rubyrel database
    attr_reader :database
    alias :db :database
    
    # The model namespace
    attr_reader :model_namespace
    
    # Creates an engine instance, using a sequel database
    # handler for the persistence layer.
    def initialize(handler, model_namespace)
      @database = ::Rubyrel::connect(handler)
      @model_namespace = @database.namespace(model_namespace)
      @processes = {}
    end
    
    ###########################################################################
    ### About structural entities
    ###########################################################################
    
    # Finds the tuple of some entity whose singular name is given.
    # Raises an UnknownEntityError if the entity does not exists.
    def entity_tuple(singular)
      tuples = db.structural.entities.restrict(:name => singular.to_s).to_a
      case tuples.size
        when 0
          raise ::CliPrEasy::UnknownEntityError, "Unknown entity #{singular}"
        when 1
          tuples[0]
        else
          raise "Unexpected case: more than one tuple for entity #{singular}"
      end
    end
    
    # Finds the tuple for some entity attribute.
    # Raises an UnknownEntityAttributeError if the attribute is unknown.
    def entity_attribute(entity, attribute)
      tuples = db.structural.entity_attributes.restrict(:entity => entity.to_s, :name => attribute.to_s).to_a
      case tuples.size
        when 0
          raise ::CliPrEasy::UnknownEntityAttributeError, "Unknown entity attribute #{entity}.#{attribute}"
        when 1
          tuples[0]
        else
          raise "Unexpected case: more than one tuple for entity #{singular}"
      end
    end
    
    # Returns the plural form of singular entity name
    def plural_of(singular)
      entity_tuple(singular).plural
    end
    
    # Returns candidates for an entity, attribute pair
    def candidates_for(entity, attribute)
      if ref = entity_attribute(entity, attribute).references
        model_namespace.relvar(plural_of(ref))
      else
        []
      end
    end
    
    ###########################################################################
    ### About screens
    ###########################################################################

    # Finds the tuple of some screen whose code is given.
    # Raises an UnknownScreenError if the screen does not exists.
    def screen_tuple(code)
      return code if code.kind_of?(::Rubyrel::Tuple)
      tuples = db.views.screens.restrict(:code => code.to_s).to_a
      case tuples.size
        when 0
          raise ::CliPrEasy::UnknownScreenError, "Unknown screen #{code}"
        when 1
          tuples[0]
        else
          raise "Unexpected case: more than one tuple for screen #{screen}"
      end
    end
    alias :screen :screen_tuple
    
    # Returns fields of a given screen
    def screen_fields(screen)
      db.views.screen_fields.restrict(:screen => screen_tuple(screen).code)
    end
    
    # Renders a screen
    def render_screen(code, formdata = {})
      renderer = ::CliPrEasy::WebTools::Screen2Html.new(self)
      rendered.render_screen(code, formdata)
    end
    
    ###########################################################################
    ### About processes
    ###########################################################################
    
    # Finds a process from its identifier
    def process(process_id)
      @processes[process_id] ||= ::CliPrEasy::Persistence::Rubyrel::load_process(database, process_id)
    end
    
    # Finds a statement inside a process
    def statement(process_id, statement_id)
      process = process(process_id)
      process ? process.statement_by(:identifier, statement_id) : nil
    end
    
  end # class Engine
end # module CliPrEasy