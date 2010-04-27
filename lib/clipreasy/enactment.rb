Dir[File.join(File.dirname(__FILE__), 'enactment', '*.rb')].each do |file|
  require "clipreasy/enactment/#{File.basename(file, '.rb')}"
end
