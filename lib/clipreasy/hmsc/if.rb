module CliPrEasy
  module Model
    class If < Statement
      
      # Creates a node instance
      def to_hmsc(graph)
        ps = graph.add_vertex(::CliPrEasy::HMSC::PseudoStartNode, :pseudo_for => self)
        v = graph.add_vertex(::CliPrEasy::HMSC::IfNode, :semantics => self)
        pe = graph.add_vertex(::CliPrEasy::HMSC::PseudoEndNode, :pseudo_for => self)
        
        # connect pseudo-start to decision diamond
        graph.connect(ps, v)
        
        # Recurse on then_clause and make connections
        tcps, tcpe = then_clause.to_hmsc(graph)
        graph.connect(v, tcps, :semantics => true)
        graph.connect(tcpe, pe)
        
        # Handle the optional else case
        if else_clause
          ecps, ecpe = else_clause.to_hmsc(graph)
          graph.connect(v, ecps, :semantics => false)
          graph.connect(ecpe, pe)
        else
          graph.connect(v, pe, :semantics => false)
        end
        
        # return my pair
        [ps, pe]
      end
      
    end # class Activity
  end # module Model
end # module CliPrEasy