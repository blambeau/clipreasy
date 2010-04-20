module CliPrEasy
  module HMSC
    GRAPH_DOT_ATTRIBUTES = {:rankdir => 'TB', :ranksep => '0.3'}
    GRAPH_NODE_DOT_ATTRIBUTES = {:fontname => 'Arial', :fontsize => '12'}
    module StartNode  
      def default_dot_attributes
        {:shape => 'point', :style => 'filled', :label => ''}
      end
    end
    module EndNode        
      def default_dot_attributes
        {:shape => 'doublecircle', :style => 'filled',
        :fillcolor => 'black', :label => '', :width => 0.1}
      end
    end
    module PseudoStartNode
      def default_dot_attributes
        {:shape => 'point', :style => 'filled', :label => ''}
      end
    end
    module PseudoEndNode
      def default_dot_attributes
        {:shape => 'doublecircle', :style => 'filled',
        :fillcolor => 'black', :label => '', :width => 0.1}
      end
    end
    module ActivityNode
      def default_dot_attributes
        {:shape => 'box', :style => nil,
         :fixedsize => true, :width => 1.5, :height => 0.4,
         :label => semantics.label || semantics.business_id}
      end
    end
    module DecisionNode
      def default_dot_attributes
        {:shape => 'diamond', :style => nil,
         :fixedsize => true, :width => 0.7, :height => 0.7,
         :label => semantics.condition}
      end
    end
    module ForkNode
      def default_dot_attributes
        {:shape => 'box', :style => 'filled', :label => '',
         :fillcolor => 'black', :fixedsize => true, :width => 0.7, 
         :height => 0.1}
      end
    end
    module JoinNode
      def default_dot_attributes
        {:shape => 'box', :style => 'filled', :label => '',
         :fillcolor => 'black', :fixedsize => true, :width => 0.7, 
         :height => 0.1}
      end
    end
    module UntilNode
      def default_dot_attributes
        {:shape => 'diamond', :style => nil,
         :fixedsize => true, :width => 0.7, :height => 0.7,
         :label => semantics.condition}
      end
    end
    module WhileNode
      def default_dot_attributes
        {:shape => 'diamond', :style => nil,
         :fixedsize => true, :width => 0.7, :height => 0.7,
         :label => semantics.condition}
      end
    end
  end # module HMSC
end # module CliPrEasy
require "clipreasy/hmsc/activity"
require "clipreasy/hmsc/decision"
require "clipreasy/hmsc/parallel"
require "clipreasy/hmsc/sequence"
require "clipreasy/hmsc/until"
require "clipreasy/hmsc/while"
require "clipreasy/hmsc/process"
