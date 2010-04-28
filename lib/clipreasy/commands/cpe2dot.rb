module CliPrEasy
  module Commands
    class Cpe2Dot < Command

      # Output buffer
      attr_accessor :out

      # Gif file?
      attr_accessor :gif

      # Creates a command instance
      def initialize
        super
        @out = STDOUT
        @gif = false
      end

      # Contribute to options
      def add_options(opt)
        opt.on("--output=FILE", "Flush output in the given file") do |value|
          @out = value
        end
        opt.on('--gif', "Generate a gif file instead of a dot one (requires dot in path)") do 
          @gif = true
        end
      end
      
      # Returns the command banner
      def banner
        "cpe2dot - convert clipreasy process files to dot/gif files"
      end
      
      # Checks that the command may be safely executed!
      def check_command_policy
        true
      end
      
      # Runs the sub-class defined command
      def _run(root_folder, arguments)
        exit("Missing .cpe file", true) unless arguments.size == 1
        source_file = arguments[0]
        process = CliPrEasy::Persistence::XML::decode_process_file(source_file)
        if @gif
          exit('Gif options requires --output') if @out == STDOUT
          process.to_dot_gif(@out)
        else
          @out = File.open(@out, 'w') if @out != STDOUT
          @out << process.to_dot
          @out.close unless @out == STDOUT
        end
      end
      
    end # class Cpe2Dot
  end # module Commands
end # module CliPrEasy