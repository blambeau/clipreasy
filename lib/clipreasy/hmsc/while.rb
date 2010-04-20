module CliPrEasy
  module Lang
    module While
      
      # Creates a node instance
      def to_hmsc(graph)
        ps = graph.add_vertex(::CliPrEasy::HMSC::PseudoStartNode, :pseudo_for => self)
        v = graph.add_vertex(::CliPrEasy::HMSC::WhileNode, :semantics => self)
        pe = graph.add_vertex(::CliPrEasy::HMSC::PseudoEndNode, :pseudo_for => self)
        
        # connect pseudo-start to decision diamond
        graph.connect(ps, v)
        
        # Recurse on then_clause make connections
        tcps, tcpe = self.then.to_hmsc(graph)
        # decision diamond to then_clause's pseudo-start for true
        graph.connect(v, tcps, :semantics => true)
        # then_clause's pseudo end to decision's pseudo_start
        graph.connect(tcpe, ps)
        # decision diamons to pseudo_end for true
        graph.connect(v, pe, :semantics => false)
        
        # return my pair
        [ps, pe]
      end
      
    end # class Activity
  end # module Lang
end # module CliPrEasy