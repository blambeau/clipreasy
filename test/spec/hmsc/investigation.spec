require File.expand_path('../../../spec_helper', __FILE__)

describe "Convertion of a process to an hMSC graph" do
  include ::CliPrEasy::Fixtures
  
  it "should return a Digraph instance" do
    graph = work_and_coffee_process.to_hmsc
    graph.should be_a(::Yargi::Digraph)
  end
  
  it "should provide a to_dot helper" do
    work_and_coffee_process.should respond_to(:to_dot)
  end
  
  it "should provide a helper for creating .gif files" do
    process_files.each do |process_file|
      folder = File.dirname(process_file)
      name = File.basename(process_file, '.cpe')
      output = File.join(folder, "#{name}.gif")
      process = xml_process_decode(process_file)
      process.to_dot_gif(output)
    end
  end
  
end
