require 'clipreasy'
describe "In-Memory enactment" do
  include CliPrEasy::Fixtures
  
  it "should provide a simple support for starting process executions" do
    factory = ::CliPrEasy::Enactment::Memory::ExecutionFactory.new
    enacter = ::CliPrEasy::Enactment::Enacter.new(factory)
    
    # start the process
    process_exec, terminal_execs = enacter.start_execution(work_and_coffee_process)
    
    # check result
    (::CliPrEasy::Enactment::AbstractProcessExecution === process_exec).should be_true
    Array.should === terminal_execs
    
    # # make steps until no one can be found anymore
    # until terminal_execs.empty?
    #   terminal_execs.all?{|t| (::CliPrEasy::Enactment::AbstractStatementExecution === t).should be_true}
    #   terminal_execs = terminal_execs.collect{|t| t.close}.flatten
    # end
  end
  
end