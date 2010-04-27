require 'clipreasy'
describe ::CliPrEasy::Enactment::Activity do
  include ::CliPrEasy::Fixtures
  
  it "should implement the enactment contract correctly" do
    process = process('activity')
    process_exec = ::CliPrEasy::Enactment::State.new(process)
    terminals = process.start(process_exec)

    # process and activity executions are pending now
    process_exec.pending?.should be_true
    terminals.size.should == 1
    terminals[0].statement.should == process.statement_by(:business_id, 'activity')
    terminals[0].pending?.should be_true
    terminals[0].resume.should be_empty

    # process and activity executions are ended now
    process_exec.pending?.should be_false
    terminals[0].pending?.should be_false
  end

end