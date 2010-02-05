require 'clipreasy'
describe "In-Memory enactment" do
  include CliPrEasy::Fixtures
  
  it "should provide a simple support for starting process executions" do
    process = work_and_coffee_process
    factory = ::CliPrEasy::Enactment::Memory::ExecutionFactory.new
    tired, too_much = nil, true
    enacter = ::CliPrEasy::Enactment::Enacter.new(factory) do |expression|
      case expression.strip
        when "tired?"
          old, tired = tired, true
          old
        when 'too_much_coffee?'
          old, too_much = too_much, true
          old
        when "true"
          true
        else
          raise "Unexpected expression #{expression}"
      end
    end
    
    # start the process
    process_exec, terminal_execs = enacter.start_execution(process)
    
    # check result
    (::CliPrEasy::Enactment::AbstractProcessExecution === process_exec).should be_true
    Array.should === terminal_execs
    
    # First level led to 'say_hello'
    terminal_execs.size.should == 1
    terminal_execs[0].statement.should == process.statement_by_business_id('say_hello')
    
    # lauch next level
    terminal_execs = terminal_execs[0].activity_ended
    
    # Second level led to ['work', 'drink']
    terminal_execs.size.should == 2
    terminal_execs[0].statement.should == process.statement_by_business_id('work')
    terminal_execs[1].statement.should == process.statement_by_business_id('drink')
    
    # Close the drink one now => ['go_somewhere']
    next_execs = terminal_execs[1].activity_ended
    next_execs.size.should == 1
    next_execs[0].statement.should == process.statement_by_business_id('go_somewhere')
    
    # Close the 'go_somewhere' task now
    next_execs = next_execs[0].activity_ended
    next_execs.should be_empty
    
    # Close the 'work' task
    terminal_execs = terminal_execs[0].activity_ended
    terminal_execs.size.should == 1
    terminal_execs[0].statement.should == process.statement_by_business_id('say_goodbye')
    
    # Close the 'say_goodbye' task
    terminal_execs[0].activity_ended.should be_empty
  end
  
end