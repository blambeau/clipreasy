require 'clipreasy'
describe ::CliPrEasy::Enactment::Until do
  include ::CliPrEasy::Fixtures
  
  it "should implement the enactment contract correctly, on until" do
    i = 0
    process = process('until')
    enacter = memory_enacter{|e| 
      e == 'ended?' ? i == 1 : Kernel.eval(e)
    }
    process_exec, terminals = enacter.start_execution(process)

    # process and activity execution are pending now
    pending?(process_exec, terminals).should be_true
    
    # check result
    terminals.size.should == 1
    terminals[0].statement.should == process.statement_by(:business_id, "dot_it_activity")
    pending?(terminals).should be_true
    
    terminals = terminals[0].activity_ended
    terminals.size.should == 1
    terminals[0].statement.should == process.statement_by(:business_id, "dot_it_activity")
    pending?(terminals).should be_true

    # close it now
    i = 1
    terminals[0].activity_ended.should be_empty
    ended?(process_exec, terminals).should be_true
  end
  
end