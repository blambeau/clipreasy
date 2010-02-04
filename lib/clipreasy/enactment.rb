require "clipreasy/enactment/abstract_statement_execution"
require "clipreasy/enactment/abstract_process_execution"
Dir[File.join(File.dirname(__FILE__), 'enactment', '*.rb')].each do |file|
  require "clipreasy/enactment/#{File.basename(file, '.rb')}"
end
