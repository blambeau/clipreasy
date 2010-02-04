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
      files.each{|f| yield(f)} if block_given?
      files
    end
    
    # Decodes a process file encoded in the process format and returns it
    def xml_process_decode(file)
      require 'clipreasy/persistence/xml/process_xml_decoder'
      ::CliPrEasy::Persistence::XML::ProcessXMLDecoder.decode_file(file)
    end
    
    # Returns an array with all processes in the fixtures subfolder. If a 
    # block is given, yields it with each process instance.
    def all_processes
      processes = process_files.collect{|f| xml_process_decode(f)}
      processes.each{|p| yield(p)} if block_given?
      processes
    end
    
    # Returns the work_and_cofee process decoded through the XML
    # persistence decoder.
    def work_and_coffee_process
      xml_process_decode(process_file("work_and_coffee.cpe"))
    end
    
  end # module Fixtures
end # module CliPrEasy