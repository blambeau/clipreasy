require 'rexml/document'
module CliPrEasy
  module Engine
    
    #
    # Decodes process definitions in the CliPrEasy XML format.
    #
    class ProcessXMLDecoder
      
      # Try to affect attributes to a factored statement. Returns who.
      def self.set_xml_attributes(who, element)
        element.attributes.each do |name,value|
          accessor = "#{name}=".to_sym
          if who.respond_to?(accessor)
            who.send(accessor, value)
          else
            puts "Warning: #{who.class} does not have accessor for #{name}"
          end
        end
        who
      end
      
      # Decodes a given element
      def self.decode_element(element)
        case element.name.to_sym
          when :process
            p = Process.new(decode_element(element.elements[2]))
            p.description = element.elements[1].get_text.to_s.strip
            set_xml_attributes(p, element)
          when :formaldef
            decode_element(element.elements[1])
          when :sequence
            statements = element.elements.collect{|e| decode_element(e)}
            set_xml_attributes(Sequence.new(statements), element)
          when :parallel
            statements = element.elements.collect{|e| decode_element(e)}
            set_xml_attributes(Parallel.new(statements), element)
          when :activity
            set_xml_attributes(Activity.new, element)
          when :decision
            condition = element.attribute("condition").to_s
            clauses = element.elements.collect{|e| decode_element(e)}
            set_xml_attributes(Decision.new(condition, clauses), element)
          when :when
            value = element.attribute("value").to_s
            then_clause = decode_element(element.elements[1])
            set_xml_attributes(When.new(value, then_clause), element)
          when :until
            condition = element.attribute("condition").to_s
            then_clause = decode_element(element.elements[1])
            set_xml_attributes(Until.new(condition, then_clause), element)
          when :while
            condition = element.attribute("condition").to_s
            then_clause = decode_element(element.elements[1])
            set_xml_attributes(While.new(condition, then_clause), element)
          else
            raise "Unexpected element #{element.inspect}"
        end
      end
      
      # Decodes a XML encoding of a workflow
      def self.decode(xml)
        xml_doc = REXML::Document.new(xml.strip) unless REXML::Document===xml
        process = decode_element(xml_doc.root)
        token = -1
        process.depth_first_search do |statement|
          statement.statement_token = (token += 1)
        end
        process.formaldef = xml.strip
        process
      end
      
      # Decodes a process whose XML definition is inside a file
      def self.decode_file(path)
        process = decode(File.read(path))
        process.folder = File.expand_path(File.dirname(path))
        process
      end
      
    end # class ProcessXMLDecoder

  end # module Engine
end # module CliPrEasy