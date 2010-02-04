module CliPrEasy
  module Fixtures
    
    # Returns the fixtures folder
    def fixtures_folder
      File.expand_path(File.join(File.dirname(__FILE__), 'fixtures'))
    end
    
    # Returns an array with process files
    def process_files
      Dir[File.join(fixtures_folder, '**', '*.cpe')]
    end
    
    # Finds a process file by name
    def process_file(name)
      process_files.find{|f| File.basename(f) == name}
    end
    
    # Returns an array containing all .cpe files contained
    # under the fixtures folder. If a block is given yields
    # it with each file in turn
    def all_process_files
      files = process_files.collect{|f| File.expand_path(f)}
      files.each{|f| yield f} if block_given?
      files
    end
    
    # Returns the work_and_cofee process decoded through the XML
    # persistence decoder.
    def work_and_coffee_process
      require 'clipreasy/persistence/xml/process_xml_decoder'
      file = process_file("work_and_coffee.cpe")
      ::CliPrEasy::Persistence::XML::ProcessXMLDecoder.decode_file(file)
    end
    
  end # module Fixtures
end # module CliPrEasy