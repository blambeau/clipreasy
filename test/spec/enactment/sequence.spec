require 'clipreasy'
describe ::CliPrEasy::Enactment::Sequence do
  include ::CliPrEasy::Fixtures
  
  it "should implement the enactment contract correctly" do
    process = process('sequence')
    process_exec = ::CliPrEasy::Enactment::State.new(process)
    terminals = process.start(process_exec)

    # process and activity executions are pending now
    pending?(process_exec, terminals).should be_true
    
    # check result
    terminals.size.should == 1
    terminals[0].statement.business_id.should == "activity1"

    # check result
    terminals = terminals[0].resume
    terminals.size.should == 1
    terminals[0].statement.business_id.should == "activity2"
    
    # check result
    terminals = terminals[0].resume
    terminals.size.should == 1
    terminals[0].statement.business_id.should == "activity3"
    
    # check result
    terminals = terminals[0].resume
    terminals.size.should == 0
  
    ended?(process_exec).should be_true
  end

end