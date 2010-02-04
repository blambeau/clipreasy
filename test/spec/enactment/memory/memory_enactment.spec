require 'clipreasy'
describe "In-Memory enactment" do
  include CliPrEasy::Fixtures
  
  it "should provide a simple support for starting process executions" do
    factory = ::CliPrEasy::Enactment::Memory::ExecutionFactory.new
    enacter = ::CliPrEasy::Enactment::Enacter.new(factory)
    process_exec, terminal_execs = enacter.start_execution(work_and_coffee_process)
    ::CliPrEasy::Enactment::AbstractProcessExecution.should === process_exec
    Array.should === terminal_execs
    terminal_execs.all?{|t| ::CliPrEasy::Enactment::AbstractStatementExecution.should === t}
  end
  
end