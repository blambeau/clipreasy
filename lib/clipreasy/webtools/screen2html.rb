module CliPrEasy
  module WebTools
    class Screen2Html
      include ::CliPrEasy::WebTools::WidgetHelpers
      
      # The engine
      attr_reader :engine
      
      # Creates an converter instance with a given database to find
      # combobox candidates and others...
      def initialize(engine)
        @engine = engine
      end
      
      # Finds the candidates for a given screen_field tuple
      def find_candidates(screen_field_tuple)
        engine.candidates_for(screen_field_tuple.entity, screen_field_tuple.attribute)
      end
      
      # Renders a screen from tuples
      def render_screen(code, formdata = {}, io = "")
        io << "<table>" << "\n"
        engine.screen_fields(code).each_with_index{|tuple, i| 
          io << render_screen_field(tuple, i%2==0, formdata) << "\n"
        }
        io << "</table>"
        io
      end
      
      # Renders a screen field
      def render_screen_field(screen_field_tuple, even, formdata) 
        css, label, field = (even ? 'even' : 'odd'), 
                            encode_html_entities(screen_field_tuple.label), 
                            render_screen_field_widget(screen_field_tuple, formdata)       
        %Q{\t<tr class="#{css}">\n\t\t<td>#{label}</td>\n\t\t<td>#{field}</td>\n\t</tr>}
      end
      
      # Renders a screen field
      def render_screen_field_widget(screen_field_tuple, formdata) 
        kind, options = screen_field_tuple.widget, screen_field_tuple.widget_options
        raise ArgumentError, "Unknown widget #{kind}" unless self.respond_to?(kind)
        
        name = "#{screen_field_tuple.entity}.#{screen_field_tuple.attribute}"
        candidates = find_candidates(screen_field_tuple)
        
        self.send(kind, name, candidates, formdata, options)
      end
      
    end # module Scree2Html
  end # module WebTools
end # module CliPrEasy