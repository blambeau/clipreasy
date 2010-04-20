module CliPrEasy
  module Lang
    module Sequence
      
      # Creates a node instance
      def to_hmsc(graph)
        ps = graph.add_vertex(::CliPrEasy::HMSC::PseudoStartNode, :pseudo_for => self)
        pe = graph.add_vertex(::CliPrEasy::HMSC::PseudoEndNode, :pseudo_for => self)
        
        current = ps
        # Recurse on statements
        children.each do |s|
          sps, spe = s.to_hmsc(graph)
          graph.connect(current, sps)
          current = spe
        end
        graph.connect(current, pe)
        
        # return my pair
        [ps, pe]
      end
      
    end # class Activity
  end # module Lang
end # module CliPrEasy