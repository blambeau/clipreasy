module CliPrEasy
  module Lang
    module Decision 
      
      # Creates a node instance
      def to_hmsc(graph)
        ps = graph.add_vertex(::CliPrEasy::HMSC::PseudoStartNode, :pseudo_for => self)
        v = graph.add_vertex(::CliPrEasy::HMSC::DecisionNode, :semantics => self)
        pe = graph.add_vertex(::CliPrEasy::HMSC::PseudoEndNode, :pseudo_for => self)
        
        # connect pseudo-start to decision diamond
        graph.connect(ps, v)
        
        # Recurse on when_clause's then_clauses and make connections
        children.each do |when_clause|
          raise "Unexpected clause #{clause}" unless When===when_clause
          tcps, tcpe = when_clause.then.to_hmsc(graph)
          # decision diamond to then_clause's pseudo-start
          graph.connect(v, tcps, :semantics => when_clause.value)
          # then_clause's pseudo end to decision's pseudo_end
          graph.connect(tcpe, pe)
        end
        if children.size == 1 
          graph.connect(v, pe, :semantics => "else")
        end
        
        # return my pair
        [ps, pe]
      end
      
    end # class Activity
  end # module Lang
end # module CliPrEasy