require 'clipreasy'
describe ::CliPrEasy::Enactment::Parallel do
  include ::CliPrEasy::Fixtures
  
  it "should implement the enactment contract correctly" do
    enacter, process = memory_enacter, process('parallel')
    process_exec, terminals = enacter.start_execution(process)

    # process and activity executions are pending now
    pending?(process_exec, terminals).should be_true
    
    # check result
    terminals.size.should == 3
    terminals.all?{|s| s.statement.is_a?(::CliPrEasy::Lang::Activity)}.should be_true
    
    # close them all in turn and arbitrary order
    terminals[1].activity_ended.should be_empty
    ended?(terminals[1]).should be_true
    pending?(process_exec, terminals[0], terminals[2]).should be_true
    
    terminals[0].activity_ended.should be_empty
    ended?(terminals[0], terminals[1]).should be_true
    pending?(process_exec, terminals[2]).should be_true

    terminals[2].activity_ended.should be_empty
    ended?(process_exec, terminals[0], terminals[1], terminals[2]).should be_true
  end

end