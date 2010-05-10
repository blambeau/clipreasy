require 'cgi'
module CliPrEasy
  module WebTools
    module WidgetHelpers
      
      # Standard html attributes
      HTML_ATTRIBUTES = { :class => nil, :id => nil, :onchange => nil }
      
      # HTML attributes for textinputs
      HTML_TEXTINPUT_OPTIONS = HTML_ATTRIBUTES
      TEXTINPUT_OPTIONS      = { }
      TEXTINPUT_BOTH         = HTML_TEXTINPUT_OPTIONS.merge(TEXTINPUT_OPTIONS)
      
      # HTML attributes for dateinputs
      HTML_DATEINPUT_OPTIONS = HTML_ATTRIBUTES.merge(:class => "datepicker")
      DATEINPUT_OPTIONS      = { }
      DATEINPUT_BOTH         = HTML_DATEINPUT_OPTIONS.merge(DATEINPUT_OPTIONS)
      
      # HTML attributes for textareas
      HTML_TEXTAREA_OPTIONS = HTML_ATTRIBUTES.merge(:rows => 5, :cols => 40)
      TEXTAREA_OPTIONS      = { }
      TEXTAREA_BOTH         = HTML_TEXTAREA_OPTIONS.merge(TEXTAREA_OPTIONS)
      
      # HTML attributes for combo-boxes
      HTML_COMBO_OPTIONS = HTML_ATTRIBUTES
      COMBO_OPTIONS      = { :with_none => false, :label => :label, :value => :value}
      COMBO_BOTH         = HTML_COMBO_OPTIONS.merge(COMBO_OPTIONS)
      
      # HTML attributes for yes-no radio
      HTML_YESNO_RADIO_OPTIONS = HTML_ATTRIBUTES
      YESNO_RADIO_OPTIONS = {}
      YESNO_RADIO_BOTH = HTML_YESNO_RADIO_OPTIONS.merge(YESNO_RADIO_OPTIONS)
      
      # HTML attributes for yes-no radio
      HTML_YESNO_CHECKBOX_OPTIONS = HTML_ATTRIBUTES
      YESNO_CHECKBOX_OPTIONS = {}
      YESNO_CHECKBOX_BOTH = HTML_YESNO_CHECKBOX_OPTIONS.merge(YESNO_CHECKBOX_OPTIONS)
      
      # HTML attributes for checkboxes
      HTML_CHECKBOXES_OPTIONS = HTML_ATTRIBUTES
      CHECKBOXES_OPTIONS = { :label => :label, :value => :value }
      CHECKBOXES_BOTH = HTML_CHECKBOXES_OPTIONS.merge(CHECKBOXES_OPTIONS)
      
      #############################################################################################
      ### Utility methods
      #############################################################################################
      
      # Encodes a string against html entities
      def encode_html_entities(str)
        str.nil? ? "" : CGI::escapeHTML(str.to_s)
      end
      
      # Extracts and encode value and label
      def value_and_label(candidate, options)
        [candidate[options[:value]], candidate[options[:label]]].collect{|v| encode_html_entities(v)}
      end
      
      # Converts options to HTML attributes
      def options_to_html_attrs(options, fromopts)
        buffer = ""
        fromopts.keys.each do |k|
          buffer << " #{k}=\"#{encode_html_entities(options[k])}\"" unless options[k].nil?
        end
        buffer
      end
      
      # Normalizes some form data
      def normalize_formdata(name, formdata)
        formdata = {} if formdata.nil?
        formdata = {name => formdata} unless Hash===formdata
        formdata
      end
      
      #############################################################################################
      ### Text-based widgets
      #############################################################################################
      
      #
      # Formats a textinput widget
      #
      def text_input(name, candidates, formdata={}, options = {})
        formdata = normalize_formdata(name, formdata)
        name, value = encode_html_entities(name), encode_html_entities(formdata[name])
        options = TEXTINPUT_BOTH.merge(options)
        options_html = options_to_html_attrs(options, HTML_TEXTINPUT_OPTIONS)

        %Q{<input#{options_html} type="text" name="#{name}" value="#{value}"/>}
      end
      
      #
      # Formats a textinput widget
      #
      def date_input(name, candidates, formdata={}, options = {})
        formdata = normalize_formdata(name, formdata)
        name, value = encode_html_entities(name), encode_html_entities(formdata[name])
        options = DATEINPUT_BOTH.merge(options)
        options_html = options_to_html_attrs(options, HTML_DATEINPUT_OPTIONS)

        %Q{<input#{options_html} type="text" name="#{name}" value="#{value}"/>}
      end
      
      #
      # Formats a textarea widget
      #
      def textarea(name, candidates, formdata={}, options = {})
        formdata = normalize_formdata(name, formdata)
        name, value = encode_html_entities(name), encode_html_entities(formdata[name])
        options = TEXTAREA_BOTH.merge(options)
        options_html = options_to_html_attrs(options, HTML_TEXTAREA_OPTIONS)
        
        %Q{<textarea#{options_html} name=\"#{name}\">#{value}</textarea>"}
      end
      
      #############################################################################################
      ### Boolean-based widgets
      #############################################################################################
      
      # Formats a yes/no radio button
      def yesno_radio(name, candidates, formdata = {}, options = {})
        formdata = normalize_formdata(name, formdata)
        
        options = YESNO_RADIO_BOTH.merge(options)
        options_html = options_to_html_attrs(HTML_YESNO_RADIO_OPTIONS, options)

        true_is_checked  = formdata[name] ? 'checked="checked"' : ''
        false_is_checked = !formdata[name] ? 'checked="checked"' : ''
        
        %Q{<input#{options_html} type="radio" name="#{name}" value="true"  #{true_is_checked}>Yes</input>} +
        %Q{<input#{options_html} type="radio" name="#{name}" value="false" #{false_is_checked}>No</input>}
      end
      
      # Formats a yes/no checkbox button
      def yesno_checkbox(name, candidates, formdata={}, options = {})
        formdata = normalize_formdata(name, formdata)
        value = formdata[name]
        name, label = encode_html_entities(name), encode_html_entities(options[:label] || '')
        
        options = YESNO_CHECKBOX_BOTH.merge(options)
        options_html = options_to_html_attrs(HTML_YESNO_CHECKBOX_OPTIONS, options)

        %Q{<input#{options_html} type="checkbox" name="#{name}" value="true"  #{value==true ? 'checked' : ''}>#{label}</input>}
      end
      
      #############################################################################################
      ### Multiple values widgets
      #############################################################################################
      
      # Formats a combobox widget
      def combobox(name, candidates, formdata = {}, options = {})
        formdata = normalize_formdata(name, formdata)

        options = COMBO_BOTH.merge(options)
        options_html = options_to_html_attrs(options, HTML_COMBO_OPTIONS)

        option_widgets = (candidates || []).collect do |candidate|
          is_selected = (formdata[name]==candidate[options[:value]] ? ' selected="selected"' : '')
          value, label = value_and_label(candidate, options)
          
          %Q{<option value="#{value}"#{is_selected}>#{label}</option>}
        end.join
        
        withnone = options[:with_none] ? "<option value=\"\"></option>" : ''

        %Q{<select name="#{encode_html_entities(name)}"#{options_html}>#{withnone}#{option_widgets}</select>}
      end
      
      # Formats a list of checkboxes
      def checkboxes(name, candidates, formdata = {}, options = {})
        formdata = normalize_formdata(name, formdata)

        options = CHECKBOXES_BOTH.merge(options)
        options_html = options_to_html_attrs(HTML_CHECKBOXES_OPTIONS, options)

        selected = (formdata[name] || [])

        candidates.collect do |candidate|
          is_selected = (selected.include?(candidate[options[:value]]) ? 'checked="checked"' : '')
          value, label = value_and_label(candidate, options)
          
          %Q{<input type="checkbox" name="#{name}[]" value="#{value}"#{is_selected}#{options_html}>#{label}</input>}
        end.join
      end


      ###
      
      # Puts top-down labels
      def topdown_labels(name, formdata)
        values = formdata[name]
        values.collect{|v| encode_html_entities(v)}.join('<br/>')
      end
      
      # Converts a boolean to Yes or No
      def yesno_label(name, formdata={})
        case formdata[name]
          when TrueClass
            'Yes'
          when FalseClass
            'No'
          else
            ''
        end
      end
      
      # Formats a date
      def date_label(name, formdata={})
        date = formdata[name]
        ampm = date.strftime("%p").downcase
        new_date = date.strftime("%B %d, %Y à %I:%M" + ampm)
        encode_html_entities(new_date)
      end
      
      # Commalist
      def commalist(name, formdata={})
        values = formdata[name]
        values.collect{|s| encode_html_entities(s)}.join(', ')
      end
      
    end # module WidgetHelpers
  end # module WebTools
end # module CliPrEasy