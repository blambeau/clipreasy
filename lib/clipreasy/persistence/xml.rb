module CliPrEasy
  module Persistence
    module XML
    
      # Decodes a process file encoded using XML
      def decode_process_file(file)
        raise ArgumentError, "No such process file #{file}" unless File.exists?(file)
        ::CliPrEasy::Persistence::XML::Decoder.new.decode_file(file)
      end
      module_function :decode_process_file
      
    end # module XML
  end # module Persistence
end # module CliPrEasy
require 'clipreasy/persistence/xml/decoder'