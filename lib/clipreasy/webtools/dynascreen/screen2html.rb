module CliPrEasy
  module WebTools
    class Screen2Html
      include ::CliPrEasy::WebTools::WidgetHelpers
      
      # Creates an converter instance with a given database to find
      # combobox candidates and others...
      def initialize(database, model_namespace, formdata = {})
        @database, @model_namespace, @formdata = database, model_namespace, formdata
      end
      
      # Finds the candidates for a given screen_field tuple
      def find_candidates(screen_field_tuple)
        entity, name = screen_field_tuple.entity, screen_field_tuple.attribute
        attr_tuple = @database.structural.entity_attributes.restrict(:entity => entity.to_s, :name => name.to_s).tuple_extract
        if attr_tuple.references
          @database.namespace(@model_namespace).relvar(::CliPrEasy::Structural::plural_of(@database, attr_tuple.references))
        else
          []
        end
      end
      
      # Renders a screen from tuples
      def render_screen(screen_tuple, screen_field_tuples, io = STDOUT)
        io << "<table>" << "\n"
        screen_field_tuples.each_with_index{|tuple, i| 
          io << render_screen_field(tuple, i%2==0) << "\n"
        }
        io << "</table>"
      end
      
      # Renders a screen field
      def render_screen_field(screen_field_tuple, even) 
        css, label, field = (even ? 'even' : 'odd'), 
                            encode_html_entities(screen_field_tuple.label), 
                            render_screen_field_widget(screen_field_tuple)       
        %Q{\t<tr class="#{css}">\n\t\t<td>#{label}</td>\n\t\t<td>#{field}</td>\n\t</tr>}
      end
      
      # Renders a screen field
      def render_screen_field_widget(screen_field_tuple) 
        kind, options = screen_field_tuple.widget, screen_field_tuple.widget_options
        raise ArgumentError, "Unknown widget #{kind}" unless self.respond_to?(kind)
        
        name = "#{screen_field_tuple.entity}.#{screen_field_tuple.attribute}"
        candidates = find_candidates(screen_field_tuple)
        formdata = @formdata
        
        self.send(kind, name, candidates, formdata, options.merge(:value => :code, :label => :libelle))
      end
      
    end # module Scree2Html
  end # module WebTools
end # module CliPrEasy