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
      
      # Runs the sub-class defined command
      def _run(root_folder, arguments)
        exit("Missing database handler", true) unless arguments.size == 1
        handler = arguments[0]
        
        # 1) Install database schema
        db = ::CliPrEasy::Persistence::Rubyrel::install_schema!(handler)
        
        # 2) Install meta-model data
        return unless process_folder
        folder_name = File.basename(process_folder)
        metamodel_folder = File.join(process_folder, "metamodel")
        exit("Missing metamodel subfolder", true) unless File.exists?(metamodel_folder)
        
        db.transaction do |t|
          ["roles", "actors", "entities", "entity_attributes", "screens", "screen_fields"].each do |relvar_name|
            file = File.join(metamodel_folder, "#{relvar_name}.data")
            exit("Missing file #{file}", true) unless File.exists?(file)
            t.instance_eval File.read(file)
          end
        end
        
        # 3) Creates the database schema from what is in structural tables
        c = ::CliPrEasy::Structural::Entities2Schema.new(db)
        schema = c.generate_schema("schema", folder_name.to_sym)
        schema.install_on!(db.handler)
        schema.__save_on_database(db)
        
        # Reconnect to database now
        db = ::Rubyrel::connect(handler)
        
        # 4) fill the database schema with data found in data subfolder
        data_folder = File.join(process_folder, 'data')
        db.transaction do |t|
          Dir[File.join(data_folder, '*.data')].each do |file|
            db.instance_eval File.read(file)
          end
        end if File.exists?(data_folder)

        # 5) Checks that screens can be generated safely...
        cache_folder = File.join(process_folder, 'cache')
        FileUtils.mkdir(cache_folder) unless File.exists?(cache_folder)
        db.views.screens.each do |screen_tuple|
          fields = db.views.screen_fields.restrict(:screen => screen_tuple.code)
          File.open(File.join(cache_folder, "#{screen_tuple.code}.html"),'w') do |io|
            ::CliPrEasy::WebTools::Screen2Html.new(db, folder_name.to_sym).render_screen(screen_tuple, fields, io)
          end
        end
      end
      
    end # class Cpe2Dot
  end # module Commands
end # module CliPrEasy