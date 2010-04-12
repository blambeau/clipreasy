require 'clipreasy'
require 'clipreasy/hmsc'
describe "Convertion of a process to an hMSC graph" do
  include ::CliPrEasy::Fixtures
  
  it "should return a Digraph instance" do
    graph = work_and_coffee_process.to_hmsc
    graph.should be_a(::Yargi::Digraph)
  end
  
  it "should provide a to_dot helper" do
    work_and_coffee_process.should respond_to(:to_dot)
    File.open('/tmp/hmsc.dot', "w") {|io| io << work_and_coffee_process.to_dot}
  end
  
end
