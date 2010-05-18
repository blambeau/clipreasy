require File.expand_path('../../../spec_helper', __FILE__)

describe ::CliPrEasy::Enactment::Forall do
  include ::CliPrEasy::Fixtures
  
  def start_on_forall(&block)
    process = process('forall')
    state = ::CliPrEasy::Enactment::State.new(process, nil, block)
    terminals = process.start(state)
    [process, state, terminals]
  end
  
  it "should implement the enactment contract correctly, when started on a non empty collection" do
    process, process_exec, terminals = start_on_forall{|e, state| 
      e == 'collection' ? [1, 2, 3] : Kernel.eval(e)
    }
    
    # process and activity execution are pending now
    pending?(process_exec, terminals).should be_true
    
    # check result
    terminals.size.should == 3
    terminals.all?{|t| t.statement.should == process.statement_by(:business_id, "activity")}
    
    # close them all in turn and arbitrary order
   terminals[0].resume.should be_empty
   ended?(process_exec).should be_false
   terminals[1].resume.should be_empty
   ended?(process_exec).should be_false
   terminals[2].resume.should be_empty
   ended?(process_exec, terminals).should be_true
  end

  it "should implement the enactment contract correctly, when started on an empty collection" do
    process, process_exec, terminals = start_on_forall{|e, state| 
      e == 'collection' ? [] : Kernel.eval(e)
    }
    
    # process and activity execution are pending now
    terminals.size.should == 0
    pending?(process_exec, terminals).should be_false
  end


end