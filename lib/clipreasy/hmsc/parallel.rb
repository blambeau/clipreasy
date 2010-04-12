module CliPrEasy
  module Model
    class Parallel < Statement
      
      # Creates a node instance
      def to_hmsc(graph)
        ps = graph.add_vertex(::CliPrEasy::HMSC::PseudoStartNode, :pseudo_for => self)
        fork = graph.add_vertex(::CliPrEasy::HMSC::ForkNode, :semantics => self)
        join = graph.add_vertex(::CliPrEasy::HMSC::JoinNode, :semantics => self)
        pe = graph.add_vertex(::CliPrEasy::HMSC::PseudoEndNode, :pseudo_for => self)
        
        # connect pseudo-start and pseudo-end to fork and join, respectively
        graph.connect(ps, fork)
        graph.connect(join, pe)
        
        # Recurse on statements
        statements.each do |s|
          sps, spe = s.to_hmsc(graph)
          graph.connect(fork, sps)
          graph.connect(spe, join)
        end
        
        # return my pair
        [ps, pe]
      end
      
    end # class Activity
  end # module Model
end # module CliPrEasy