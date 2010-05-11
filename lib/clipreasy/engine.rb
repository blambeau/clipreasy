module CLiPrEasy
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
    
    # Returns the plural form of singular entity name
    def plural_of(singular)
      db.structural.entities.restrict(:name => singular.to_s).tuple_extract.plural
    end
    
    # Returns candidates for an entity, attribute pair
    def candidates(entity, attribute)
      tuple = db.structural.entity_attributes.restrict(:entity => entity.to_s, :name => attribute.to_s).tuple_extract
      if tuple.references
        model_namespace.relvar(plural_of(tuple.references))
      else
        []
      end
    end
    
    ###########################################################################
    ### About screens
    ###########################################################################
    
    # Returns a tuple containing screen master information
    def screen(code)
      db.views.screens.restrict(:code => code.to_s).tuple_extract
    end
    
    # Returns 
    def screen_fields(screen)
      screen = screen.kind_of?(::Rubyrel::Tuple) ? screen.code : screen
      db.views.screen_fields.restrict(:screen => screen.to_s)
    end
    
    # Renders a screen
    def render_screen(code, formdata = {})
      renderer = ::CliPrEasy::WebTools::Screen2Html.new(self, formdata)
      rendered.render_screen(code)
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