require 'clipreasy'
describe ::CliPrEasy::Enactment::Until do
  include ::CliPrEasy::Fixtures
  
  def start_on_until(&block)
    process = process('until')
    state = ::CliPrEasy::Enactment::State.new(process, nil, block)
    terminals = process.start(state)
    [process, state, terminals]
  end
  
  it "should implement the enactment contract correctly, on until" do
    i = 0
    process, process_exec, terminals = start_on_until{|e, state| 
      e == 'ended?' ? i == 1 : Kernel.eval(e)
    }

    # process and activity execution are pending now
    pending?(process_exec, terminals).should be_true
    
    # check result
    terminals.size.should == 1
    terminals[0].statement.should == process.statement_by(:business_id, "dot_it_activity")
    pending?(terminals).should be_true
    
    terminals = terminals[0].resume
    terminals.size.should == 1
    terminals[0].statement.should == process.statement_by(:business_id, "dot_it_activity")
    pending?(terminals).should be_true

    # close it now
    i = 1
    terminals[0].resume.should be_empty
    ended?(process_exec, terminals).should be_true
  end
  
end