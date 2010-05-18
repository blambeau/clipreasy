module CliPrEasy
  module Lang
    module Forall
      
      # Creates a node instance
      def to_hmsc(graph)
        ps = graph.add_vertex(::CliPrEasy::HMSC::PseudoStartNode, :pseudo_for => self)
        vs = graph.add_vertex(::CliPrEasy::HMSC::ForallNode, :semantics => self)
        ve = graph.add_vertex(::CliPrEasy::HMSC::ForallNode, :semantics => self)
        pe = graph.add_vertex(::CliPrEasy::HMSC::PseudoEndNode, :pseudo_for => self)
        
        # connect pseudo-start to forall mcircle
        graph.connect(ps, vs)
        
        # Recurse on then_clause make connections
        tcps, tcpe = self.then.to_hmsc(graph)
        # starting mcircle to then_clause's pseudo-start
        graph.connect(vs, tcps)
        # then_clause's pseudo end to ending mcircle
        graph.connect(tcpe, ve)
        # ending mcircle to pe now
        graph.connect(ve, pe)
        
        # return my pair
        [ps, pe]
      end
      
    end # class Forall
  end # module Lang
end # module CliPrEasy