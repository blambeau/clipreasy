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
        metamodel_folder = File.join(process_folder, "metamodel")
        exit("Missing metamodel subfolder", true) unless File.exists?(metamodel_folder)
        
        db.transaction do |t|
          ["roles", "actors", "entities", "entity_attributes", "screens", "screen_fields"].each do |relvar_name|
            file = File.join(metamodel_folder, "#{relvar_name}.data")
            exit("Missing file #{file}", true) unless File.exists?(file)
            t.instance_eval File.read(file)
          end
        end
      end
      
    end # class Cpe2Dot
  end # module Commands
end # module CliPrEasy