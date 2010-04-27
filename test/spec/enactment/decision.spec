require 'clipreasy'
describe ::CliPrEasy::Enactment::Decision do
  include ::CliPrEasy::Fixtures
  
  def start_on_decision_1(&block)
    process = process('decision_1')
    state = ::CliPrEasy::Enactment::State.new(process, nil, block)
    terminals = process.start(state)
    [process, state, terminals]
  end
  
  it "should implement the enactment contract correctly, on decision_1 (with true)" do
    process, process_exec, terminals = start_on_decision_1{|e, state| 
      e == 'do_it?' ? true : Kernel.eval(e)
    }
    
    # process and activity execution are pending now
    pending?(process_exec, terminals).should be_true
    
    # check result
    terminals.size.should == 1
    terminals[0].statement.should == process.statement_by(:business_id, "true_activity")
    
    # close them all in turn and arbitrary order
    terminals[0].resume.should be_empty
    ended?(process_exec, terminals).should be_true
  end

  it "should implement the enactment contract correctly, on decision_1 (with false)" do
    process, process_exec, terminals = start_on_decision_1{|e, state| 
      e == 'do_it?' ? false : Kernel.eval(e)
    }
    
    # process and activity execution are pending now
    pending?(process_exec, terminals).should be_true
    
    # check result
    terminals.size.should == 1
    terminals[0].statement.should == process.statement_by(:business_id, "false_activity")
    
    # close them all in turn and arbitrary order
    terminals[0].resume.should be_empty
    ended?(process_exec, terminals).should be_true
  end

end