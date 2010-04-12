require 'clipreasy'
require 'clipreasy/hmsc'
describe "Convertion of a process to an hMSC graph" do
  include ::CliPrEasy::Fixtures
  
  it "should return a Digraph instance" do
    graph = work_and_coffee_process.to_hmsc
    graph.should be_a(::Yargi::Digraph)
    #puts graph.to_dot
  end
  
end
