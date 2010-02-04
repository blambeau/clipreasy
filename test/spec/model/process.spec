require 'clipreasy'
describe ::CliPrEasy::Model::Process do
  include ::CliPrEasy::Fixtures
  
  it "should support a depth first visit through a standard each iterator" do
    all_processes.each{|s| ::CliPrEasy::Model::Statement.should === s}
  end
  
  it "should identify all statements in same order as the depth first search" do
    all_processes.each{|p| p.each_with_index{|s, i| s.identifier.should === i}}
  end
  
  it "should support breaking the depth_first_search on find" do
    act = work_and_coffee_process.find{|s| s.business_id == "drink"}
    ::CliPrEasy::Model::Activity.should === act
    act.business_id.should == "drink"
  end
  
  it "should respect the tree hiearchy" do
    process = work_and_coffee_process
    process.parent.should be_nil
    process.main.parent.should == process
    hierarchy = process.inject(Hash.new{|h,k| h[k] = []}){|memo,s| memo[s.parent ? s.parent.business_id : nil] << s.business_id; memo}
    hierarchy.should == {
      nil               => ['work_and_coffee'],
      'work_and_coffee' => ['main_seq'],
      'main_seq'        => ['say_hello', 'until_tired', 'say_goodbye'],
      'until_tired'     => ['until_tired_par'],
      'until_tired_par' => ['work', 'drink_seq'],
      'drink_seq'       => ['drink', 'too_much_coffee'],
      'too_much_coffee' => ['too_much_coffee_true'],
      'too_much_coffee_true' => ['go_somewhere']
    }
    
  end

end