module CliPrEasy
  module Lang
    class Decoder
    
      # Creates a decoder instance
      def initialize
        @stack = []
        @relvars = Hash.new{|h,k| h[k] = []}
      end
      
      # Executes a statement
      def execute(name, &block)
        node = ::CliPrEasy::Lang::Node.new(
          :kind             => ::CliPrEasy::Lang::const_get(name.to_s[0...1].upcase + name.to_s[1..-1]),
          :process          => @process,
          :parent           => @parent, 
          :identifier       => @identifier,
          :children         => []
        )
        @parent.children << node if @parent

        # Save local state, recurse, restore
        @parent, @identifier, oldparent = node, @identifier+1, @parent
        self.instance_eval(&block) if block
        @parent = oldparent
        
        node
      end
      def activity(args)   
        execute(:activity).merge(args)
      end
      def decision(condition, args = {}, &block) 
        args.merge!(:condition => condition)
        execute(:decision, &block).merge(args)
      end
      def parallel(args = {}, &block) 
        # TODO: implement children
        execute(:parallel, &block).merge(args)
      end
      def sequence(args = {}, &block) 
        # TODO: implement children
        execute(:sequence, &block).merge(args)
      end
      def when(value, args = {}, &block) 
        # TODO: implement then
        args.merge!(:value => value)
        execute(:when, &block).merge(args)
      end
      alias :upon :when
      def while_do(condition, args = {}, &block)
        # TODO: implement then
        args.merge!(:condition => condition)
        execute(:while, &block).merge(args)
      end
      def until_do(condition, args = {}, &block)
        # TODO: implement then
        args.merge!(:condition => condition)
        execute(:until, &block).merge(args)
      end
      
      # Starts decoding a process
      def process(args, &block)
        @process = ::CliPrEasy::Lang::Node.new(
          args.merge(:kind    => ::CliPrEasy::Lang::Process)
        )
        @parent, @identifier = nil, 0
        main = self.instance_eval(&block)
        @process.merge(:main => main)
      end
      
    end # class Decoder
  end # module Lang
end # module CliPrEasy

