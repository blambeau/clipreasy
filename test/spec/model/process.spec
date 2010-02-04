require 'clipreasy'
describe ::CliPrEasy::Model::Process do
  include ::CliPrEasy::Fixtures
  
  it "should support a depth first visit through a standard each iterator" do
    all_processes.each{|s| ::CliPrEasy::Model::Statement.should === s}
  end
  
  it "should identify all statements in same order as the depth first search" do
    all_processes.each{|p| p.each_with_index{|s, i| s.identifier.should === i}}
  end

end