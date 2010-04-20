module CliPrEasy
  module Lang
    class Decoder
      
      # Statements of the decoder
      STATEMENTS = [:activity, :decision, :when, :parallel, :sequence, :while, :until]
      
      # Aliases
      ALIASES = {
        :if       => [:decision, {}],
        :upon     => [:when,     {}],
        :then     => [:when,     {:value => true}],
        :else     => [:when,     {:value => false}],
        :while_do => [:while,    {}],
        :until_do => [:until,    {}]
      }
    
      # Creates a decoder instance
      def initialize(instance_eval = true)
        @instance_eval = instance_eval
      end
      
      # Checks if a given identifier is a recognized statement
      def is_statement?(statement)
        STATEMENTS.include?(statement)
      end
      
      # Checks if a given identifier is an alias
      def is_alias?(statement)
        ALIASES.include?(statement)
      end
      
      # Checks if a statement is recognized as a real statement
      # or an alias
      def is_recognized?(statement)
        (statement == :process) or is_statement?(statement) or is_alias?(statement)
      end
      
      # Returns a pair [real_statement, hash], normalized statement
      # and aliases
      def normalize(statement)
        if is_statement?(statement)
          [statement, {}]
        elsif is_alias?(statement)
          ALIASES[statement]
        else
          nil
        end
      end
      
      # Makes a post merge of some attributes
      def post_merge(args = {})
        to = (@parent || @process)
        to.merge(args) if to
      end
      
      # Recurse the DSL execution on a given block
      def recurse(block)
        return unless block
        if @instance_eval 
          self.instance_eval(&block)
        else
          block.call(self)
        end
      end
      
      # Starts decoding a process
      def process(args = {}, &block)
        @process = ::CliPrEasy::Lang::Node.new(
          args.merge(:kind    => ::CliPrEasy::Lang::Process)
        )
        @parent, @identifier = nil, 0
        recurse(block)
        @process
      end
      
      # Executes a statement
      def execute(name, *args, &block)
        raise ArgumentError, "Method should take one hash argument only"\
          unless args.empty? or args.size == 1
        hash = args[0]
        raise ArgumentError, "Method should take one hash argument only #{hash.inspect} received"\
          unless hash.nil? or Hash === hash
        node = ::CliPrEasy::Lang::Node.new(
          :kind             => ::CliPrEasy::Lang::const_get(name.to_s[0...1].upcase + name.to_s[1..-1]),
          :process          => @process,
          :parent           => @parent, 
          :identifier       => @identifier,
          :children         => []
        )
        if @parent
          @parent.children << node
        else
          @process.merge(:main => node)
        end

        # Save local state, recurse, restore
        @parent, @identifier, oldparent = node, @identifier+1, @parent
        recurse(block)
        @parent = oldparent
        
        node.merge(hash) if hash
        node
      end
      
      # Defines the DSL
      def method_missing(name, *args, &block)
        statement, hash = normalize(name)
        if statement
          execute(statement, *args, &block).merge(hash)
        else
          post_merge(name => args[0])
        end
      end
      
    end # class Decoder
  end # module Lang
end # module CliPrEasy

