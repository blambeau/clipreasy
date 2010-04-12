module CliPrEasy
  module Model
    class Process < Statement
      
      # Converts a Process instance to a hMSC graph. Returns a Yargi::Digraph
      # instance.
      def to_hmsc
        graph = ::Yargi::Digraph.new
        start_node, end_node = graph.add_vertex(::CliPrEasy::HMSC::StartNode),
                               graph.add_vertex(::CliPrEasy::HMSC::EndNode)
        mps, mpe = main.to_hmsc(graph)
        graph.connect(start_node, mps)
        graph.connect(mpe, end_node)
        graph
      end
      
    end # class Process
  end # module Model
end # module CliPrEasy
