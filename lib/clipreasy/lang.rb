require 'clipreasy/lang/node'
require 'clipreasy/lang/activity'
require 'clipreasy/lang/decision'
require 'clipreasy/lang/parallel'
require 'clipreasy/lang/sequence'
require 'clipreasy/lang/until'
require 'clipreasy/lang/when'
require 'clipreasy/lang/while'
require 'clipreasy/lang/process'
require 'clipreasy/lang/decoder'
module CliPrEasy
  module Lang
    
    # Creates a process instance
    def process(args = {}, &block)
      ::CliPrEasy::Lang::Decoder.new.process(args, &block)
    end
    module_function :process
    
  end # module Lang
end # module CliPrEasy