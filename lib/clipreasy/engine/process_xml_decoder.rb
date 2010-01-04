require 'rexml/document'
module CliPrEasy
  module Engine
    
    #
    # Decodes process definitions in the CliPrEasy XML format.
    #
    class ProcessXMLDecoder
      
      # Try to affect attributes to a factored statement
      def self.set_xml_attributes(who, element)
        element.attributes.each do |name,value|
          accessor = "#{name}=".to_sym
          if who.respond_to?(accessor)
            who.send(accessor, value)
          else
            puts "Warning: #{who.class} does not have accessor for #{name}"
          end
        end
      end
      
      # Decodes a given element
      def self.decode_element(element)
        case element.name.to_sym
          when :process
            p = Process.new(decode_element(element.elements[2]))
            p.description = element.elements[1].get_text
            set_xml_attributes(p, element)
            p
          when :formaldef
            decode_element(element.elements[1])
          when :sequence
            statements = element.elements.collect{|e| decode_element(e)}
            Sequence.new(statements)
          when :parallel
            statements = element.elements.collect{|e| decode_element(e)}
            Parallel.new(statements)
          when :activity
            id = element.attribute("id").to_s
            Activity.new(id)
          when :decision
            condition = element.attribute("condition").to_s
            clauses = element.elements.collect{|e| decode_element(e)}
            Decision.new(condition, clauses)
          when :when
            value = element.attribute("value").to_s
            then_clause = decode_element(element.elements[1])
            When.new(value, then_clause)
          when :until
            condition = element.attribute("condition").to_s
            then_clause = decode_element(element.elements[1])
            Until.new(condition, then_clause)
          when :while
            condition = element.attribute("condition").to_s
            then_clause = decode_element(element.elements[1])
            While.new(condition, then_clause)
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
        process
      end
      
      # Decodes a process whose XML definition is inside a file
      def self.decode_file(path)
        decode File.read(path)
      end
      
    end # class ProcessXMLDecoder

  end # module Engine
end # module CliPrEasy