require 'rexml/document'
module CliPrEasy
  module Persistence
    module XML
    
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
              who[name.to_s.to_sym] = value
            end
          end
          who
        end
      
        # Decodes a given element
        def self.decode_element(element)
          case element.name.to_sym
            when :process
              p = Model::Process.new(decode_element(element.elements[2]))
              p[:description] = element.elements[1].get_text.to_s.strip
              set_xml_attributes(p, element)
            when :formaldef
              decode_element(element.elements[1])
            when :sequence
              statements = element.elements.collect{|e| decode_element(e)}
              set_xml_attributes(Model::Sequence.new(statements), element)
            when :parallel
              statements = element.elements.collect{|e| decode_element(e)}
              set_xml_attributes(Model::Parallel.new(statements), element)
            when :activity
              set_xml_attributes(Model::Activity.new, element)
            when :decision
              condition = element.attribute("condition").to_s
              clauses = element.elements.collect{|e| decode_element(e)}
              set_xml_attributes(Model::Decision.new(condition, clauses), element)
            when :when
              value = element.attribute("value").to_s
              then_clause = decode_element(element.elements[1])
              set_xml_attributes(Model::When.new(value, then_clause), element)
            when :until
              condition = element.attribute("condition").to_s
              raise "Missing condition in Until" if condition.nil? or condition.strip.empty?
              then_clause = decode_element(element.elements[1])
              set_xml_attributes(Model::Until.new(condition, then_clause), element)
            when :while
              condition = element.attribute("condition").to_s
              raise "Missing condition in While" if condition.nil? or condition.strip.empty?
              then_clause = decode_element(element.elements[1])
              set_xml_attributes(Model::While.new(condition, then_clause), element)
            else
              raise "Unexpected element #{element.inspect}"
          end
        end
      
        # Decodes a XML encoding of a workflow
        def self.decode(xml)
          xml_doc = REXML::Document.new(xml.strip) unless REXML::Document===xml
          process = decode_element(xml_doc.root)
          process[:formaldef] = xml.strip
          process
        end
      
        # Decodes a process whose XML definition is inside a file
        def self.decode_file(path)
          process = decode File.read(path)
          process[:xml_source_file] = File.expand_path(path)
          process
        end
      
      end # class ProcessXMLDecoder
      
    end # module XML
  end # module Peristence
end # module CliPrEasy