module CliPrEasy
  module Commands
    class Install < Command

      # The process folder 
      attr_reader :process_folder

      # Creates a command instance
      def initialize
        super
      end

      # Contribute to options
      def add_options(opt)
        opt.on("--process-folder=FOLDER", '-p', "Install data and processes from folder") do |value|
          @process_folder = value
        end
      end
      
      # Returns the command banner
      def banner
        "install - Install clipreasy on a database handler"
      end
      
      # Checks that the command may be safely executed!
      def check_command_policy
        true
      end
      
      # Installs the base database
      def install_base_database!(handler)
        ::CliPrEasy::Persistence::Rubyrel::install_schema!(handler)
      end
      
      # Installs the meta model
      def install_meta_model!(db, folder) 
        [:roles, :actors, :entities, :entity_attributes, :screens, :screen_fields].each do |relvar_name|
          file = File.join(folder, "#{relvar_name}.data")
          next unless File.exists?(file)
          db.instance_eval File.read(file)
        end
      end
      
      # Installs the processes
      def install_processes!(db, folder)
        Dir[File.join(folder, "*.cpe")].each do |file|
          process = CliPrEasy::Persistence::XML::decode_process_file(file)
          process.save_on_relational_model(db.model)
        end
      end
      
      # Runs the sub-class defined command
      def _run(root_folder, arguments)
        exit("Missing database handler", true) unless arguments.size == 1
        handler = arguments[0]
        
        # 1) Install database schema
        db = install_base_database!(handler)
        
        # 2) Install meta-model data
        return unless process_folder
        folder_name = File.basename(process_folder)
        metamodel_folder = File.join(process_folder, "metamodel")
        exit("Missing metamodel subfolder", true) unless File.exists?(metamodel_folder)
        install_meta_model!(db, metamodel_folder)
        
        # 2.2) Install processes now
        install_processes!(db, File.join(process_folder, "processes"))
        
        # 3) Creates the database schema from what is in structural tables
        c = ::CliPrEasy::Structural::Entities2Schema.new(db)
        schema = c.generate_schema("schema", folder_name.to_sym)
        schema.install_on!(db.handler)
        schema.__save_on_database(db)
        
        # Reconnect to database now
        db = ::Rubyrel::connect(handler)
        
        # 4) fill the database schema with data found in data subfolder
        data_folder = File.join(process_folder, 'model')
        db.transaction do |t|
          Dir[File.join(data_folder, '*.data')].each do |file|
            db.instance_eval File.read(file)
          end
        end if File.exists?(data_folder)
      end
      
    end # class Cpe2Dot
  end # module Commands
end # module CliPrEasy