module CliPrEasy
  module Lang
    module Activity
      
      # Creates a node instance
      def to_hmsc(graph)
        ps = graph.add_vertex(::CliPrEasy::HMSC::PseudoStartNode, :pseudo_for => self)
        v = graph.add_vertex(::CliPrEasy::HMSC::ActivityNode, :semantics => self)
        pe = graph.add_vertex(::CliPrEasy::HMSC::PseudoEndNode, :pseudo_for => self)
        graph.connect(ps, v)
        graph.connect(v, pe)
        [ps, pe]
      end
      
    end # class Activity
  end # module Lang
end # module CliPrEasy