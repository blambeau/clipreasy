require 'rexml/document'
module CliPrEasy
  module Persistence
    module XML
      class Decoder

        # Creates a decoder instance
        def initialize
          @dsl = ::CliPrEasy::Lang::Decoder.new(false)
        end
        
        # Converts XML attributes to a hash
        def attributes_to_h(attributes)
          h = {}
          attributes.each do |name,value|
            h[name.to_sym] = value
          end
          h
        end

        # Decodes a given element
        def decode_element(element, name = element.name.to_sym)
          raise ArgumentError, "element may not be nil" if element.nil?
          case name
            when :formaldef
              element.elements.each{|e| decode_element(e)}
            else
              if @dsl.is_recognized?(name)
                @dsl.send(name, attributes_to_h(element.attributes)) do |dsl|
                  element.elements.each {|child| decode_element(child)}
                end
              elsif element.elements.size == 0
                @dsl.post_merge(element.name.to_sym => element.get_text().to_s())
              else
                puts "Warning, forgetting about #{name}"
                element.elements.each {|child| decode_element(child)}
              end
          end
        end
        
        # Decodes a XML encoding of a workflow
        def decode(xml)
          xml_doc = REXML::Document.new(xml.strip) unless REXML::Document===xml
          decode_element(xml_doc.root)
        end
      
        # Decodes a process whose XML definition is inside a file
        def decode_file(path)
          decode File.read(path)
        end
      
      end # class Decoder
    end # module XML
  end # module Persistence
end # module CliPrEasy