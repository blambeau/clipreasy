module CliPrEasy
  module Lang
    #
    # A Node in the process tree.
    #
    class Node
      
      # Creates a node instance. Arguments are automatically
      # merged inside the node.
      def initialize(args = {})
        self.extend(args[:kind]) if Module === args[:kind]
        @__args = {}
        merge(args)
      end
      
      # Merge some attributes into the node. Helper methods
      # are automatically created on the node.
      def merge(args)
        @__args.merge!(args)
        args.keys.each do |k|
          (class << self; self; end).send(:define_method, k) {
            @__args[k]
          }
        end
        self
      end
      
      # Makes a depth first search inside the tree, yielding
      # block on this instance and recursing on children.
      def depth_first_search(&block)
        yield(self)
        children && children.each{|c| c.depth_first_search(&block)}
      end
      alias :dfs :depth_first_search
      
      # Returns keys condidered private
      def private_arg_key?(key)
        [:process, :parent, :children, :identifier, :kind].include?(key)
      end
      
      # Encodes public arguments
      def public_args_encoding
        buffer = ""
        @__args.each_pair do |k, v|
          next if private_arg_key?(k)
          buffer << (buffer.empty? ? "" : ", ") << ":#{k} => #{v.inspect}"
        end
        buffer
      end
      
      # Inspects the children
      def children_inspect      
        children.collect{|c| c.inspect}.join()
      end
      
    end # module Node
  end # module Lang
end # module CliPrEasy