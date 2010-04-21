require 'clipreasy'
describe ::CliPrEasy::Enactment::Activity do
  include ::CliPrEasy::Fixtures
  
  it "should implement the enactment contract correctly" do
    process = process('activity')
    process_exec, terminals = ::CliPrEasy::Enacter::run(process)
    
    # process and activity executions are pending now
    process_exec.pending?.should be_true
    process_exec.ended?.should be_false
    terminals.size.should == 1
    terminals[0].statement.should == process.statement_by(:business_id, 'activity')
    terminals[0].pending?.should be_true
    terminals[0].ended?.should be_false
    terminals[0].close.should be_empty
    
    # process and activity executions are ended now
    process_exec.pending?.should be_false
    process_exec.ended?.should be_true
    terminals[0].pending?.should be_false
    terminals[0].ended?.should be_true
  end

end