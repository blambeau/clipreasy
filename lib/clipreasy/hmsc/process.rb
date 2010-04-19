module CliPrEasy
  module Model
    class Process < Statement
      
      # Converts a Process instance to a hMSC graph. Returns a Yargi::Digraph
      # instance.
      def to_hmsc(options = {:simplified => false, :dot_attributes => false})
        # Create the graph, basically by recursing on main statement
        graph = ::Yargi::Digraph.new
        start_node, end_node = graph.add_vertex(::CliPrEasy::HMSC::StartNode),
                               graph.add_vertex(::CliPrEasy::HMSC::EndNode)
        mps, mpe = main.to_hmsc(graph)
        graph.connect(start_node, mps)
        graph.connect(mpe, end_node)
        
        # Simplify the graph is requested
        if options[:simplified]
          entry = Yargi.predicate(::CliPrEasy::HMSC::PseudoStartNode)
          exit = Yargi.predicate(::CliPrEasy::HMSC::PseudoEndNode)
          graph.vertices(entry|exit).each do |v|
            next unless (v.out_edges.length==1 and v.in_edges.length>0)
            target = v.out_edges[0].target
            v.in_edges.target = target
            graph.remove_vertex(v)
          end
        end
        
        # Install default dot attributes if requested
        if options[:dot_attributes] 
          graph.each_vertex{|v| v.add_marks(v.default_dot_attributes)}
        end
        graph
      end
      
      # Returns a dot variant of the hmsc graph
      def to_dot
        graph = to_hmsc(:simplified => true, :dot_attributes => true)
        graph.add_marks(::CliPrEasy::HMSC::GRAPH_DOT_ATTRIBUTES)
        graph.each_vertex{|v| v.add_marks(::CliPrEasy::HMSC::GRAPH_NODE_DOT_ATTRIBUTES)}
        graph.each_edge{|e| e.add_marks(:label => e.semantics.to_s) if e.respond_to?(:semantics)}
        graph.to_dot
      end
      
      # Generates a .gif file for the process, using dot.
      def to_dot_gif(path)
        require 'tempfile'
        tmp = Tempfile.new("clipreasy_#{Time.now.to_i}.dot")
        tmp << to_dot
        tmp.close
        `dot -Tgif -o #{path} #{tmp.path}`
        tmp.unlink
        nil
      end
        
      
    end # class Process
  end # module Model
end # module CliPrEasy
