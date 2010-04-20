require 'clipreasy'
describe ::CliPrEasy::Enactment::While do
  include ::CliPrEasy::Fixtures
  
  it "should implement the enactment contract correctly, on while" do
    i = 0
    process = process('while')
    enacter = memory_enacter{|e| 
      e == 'do_it?' ? i == 0 : Kernel.eval(e)
    }
    process_exec, terminals = enacter.start_execution(process)
    main_exec = process_exec.main_execution

    # process and activity execution are pending now
    pending?(process_exec, main_exec, terminals).should be_true
    
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
    ended?(process_exec, main_exec, terminals).should be_true
  end
  
end