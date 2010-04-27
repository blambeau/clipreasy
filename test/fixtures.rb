module CliPrEasy
  module Fixtures
    
    # Returns handler for a sequel database
    def sqlite_test_database_handler
      "sqlite://#{File.join(File.expand_path(File.dirname(__FILE__)), 'fixtures', 'clipreasy.db')}"
    end
    
    # Returns handler for a sequel database
    def pgsql_test_database_handler
      "postgres://clipreasy@localhost/clipreasytest"
    end
    
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
      require 'clipreasy/persistence/xml'
      ::CliPrEasy::Persistence::XML::decode_process_file(file)
    end
    
    # Returns an array with all processes in the fixtures subfolder. If a 
    # block is given, yields it with each process instance.
    def all_processes
      processes = process_files.collect{|f| xml_process_decode(f)}
      processes.each{|p| yield(p)} if block_given?
      processes
    end
    
    # Finds a process by name (.cpe extension should not be passed)
    def process(name)
      xml_process_decode(process_file("#{name}.cpe"))
    end
    
    # Returns the work_and_cofee process decoded through the XML
    # persistence decoder.
    def work_and_coffee_process
      process('work_and_coffee')
    end
    
    # Returns the rxth_v2 process decoded through the XML
    # persistence decoder.
    def rxth_v2_process
      process('rxth_v2')
    end
    
    # Checks if some executions are pending (and not ended)
    def pending?(*execs)
      execs.flatten.all?{|e| e.pending?}
    end
    
    # Checks if some executions are ended (and not pending)
    def ended?(*execs)
      execs.flatten.all?{|e| not(e.pending?)}
    end
    
  end # module Fixtures
end # module CliPrEasy