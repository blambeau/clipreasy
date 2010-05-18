require File.expand_path('../../../spec_helper', __FILE__)

describe ::CliPrEasy::Enactment::While do
  include ::CliPrEasy::Fixtures
  
  def start_on_while(&block)
    process = process('while')
    state = ::CliPrEasy::Enactment::State.new(process, nil, block)
    terminals = process.start(state)
    [process, state, terminals]
  end
  
  it "should implement the enactment contract correctly, on while" do
    i = 0
    process, process_exec, terminals = start_on_while{|e, state| 
      e == 'do_it?' ? i == 0 : Kernel.eval(e)
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