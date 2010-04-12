module CliPrEasy
  module HMSC
    module StartNode;       end
    module EndNode;         end
    module PseudoStartNode; end
    module PseudoEndNode;   end
    module ActivityNode;    end
    module DecisionNode;    end
    module ForkNode;        end
    module JoinNode;        end
    module UntilNode;       end
    module WhileNode;       end
  end # module HMSC
end # module CliPrEasy
require "clipreasy/hmsc/statement"
require "clipreasy/hmsc/activity"
require "clipreasy/hmsc/decision"
require "clipreasy/hmsc/parallel"
require "clipreasy/hmsc/sequence"
require "clipreasy/hmsc/until"
require "clipreasy/hmsc/while"
require "clipreasy/hmsc/process"
