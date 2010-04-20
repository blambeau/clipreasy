require 'clipreasy'
describe ::CliPrEasy::Lang::Process do
  include ::CliPrEasy::Fixtures
  
  it "fixtures should return process instances" do
    all_processes.each{|s| ::CliPrEasy::Lang::Process.should === s}
  end
  
  it "should implement a depth first search through a standard ruby iterator" do
    all_processes.each{|p| p.each{|s| ::CliPrEasy::Lang::Node.should === s}}
  end
  
  it "should identify all statements in same order as the depth first search" do
    all_processes.each{|p| p.each_with_index{|s, i| s.identifier.should === i}}
  end
  
  it "should support breaking the depth_first_search on find" do
    act = work_and_coffee_process.find{|s| s.business_id == "drink"}
    ::CliPrEasy::Lang::Activity.should === act
    act.business_id.should == "drink"
  end
  
  it "should respect the tree hiearchy about main process" do
    all_processes.each{|p|
      p.all?{|s| s.process == p}.should be_true
    }
  end
  
  it "should respect the tree hiearchy about parents" do
    process = work_and_coffee_process
    #process.parent.should be_nil
    #process.main.parent.should == process
    hierarchy = process.inject(Hash.new{|h,k| h[k] = []}) do |memo,s| 
      memo[s.parent.nil? ? nil : s.parent.business_id] << s.business_id
      memo
    end
    hierarchy.should == {
      nil => ['main_seq'],
      'main_seq'        => ['say_hello', 'until_tired', 'say_goodbye'],
      'until_tired'     => ['until_tired_par'],
      'until_tired_par' => ['work', 'drink_seq'],
      'drink_seq'       => ['drink', 'too_much_coffee'],
      'too_much_coffee' => ['too_much_coffee_true'],
      'too_much_coffee_true' => ['go_somewhere']
    }
  end
  
  # it "should support a way to get a statement by its identifier" do
  #   process = work_and_coffee_process
  #   process.statement_by_identifier(0).should == process
  #   process.statement_by_identifier(1).should == process.main
  # end
  # 
  # it "should support a way to get a statement by its business id" do
  #   process = work_and_coffee_process
  #   process.statement_by_business_id('work_and_coffee').should == process
  #   process.statement_by_business_id('drink').should == process.find{|s| s.business_id=='drink'}
  # end
  # 
  # it "should support a way to get a mapping between business_ids and statements" do
  #   process = work_and_coffee_process
  #   expected = {}
  #   process.each {|s| expected[s.business_id] = s}
  #   process.map_by_business_id.should == expected
  # end

end