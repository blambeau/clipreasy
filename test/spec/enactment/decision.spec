# require 'clipreasy'
# describe ::CliPrEasy::Enactment::Decision do
#   include ::CliPrEasy::Fixtures
#   
#   def start_on_decision_1(&block)
#     process = process('decision_1')
#     enacter = memory_enacter(&block)
#     process_exec, terminals = enacter.start_execution(process)
#     main_exec = process_exec.main_execution
#     [process, enacter, process_exec, main_exec, terminals]
#   end
#   
#   it "should implement the enactment contract correctly, on decision_1 (with true)" do
#     process, enacter, process_exec, main_exec, terminals = start_on_decision_1{|e| 
#       e == 'do_it?' ? true : Kernel.eval(e)
#     }
#     
#     # process and activity execution are pending now
#     pending?(process_exec, main_exec, terminals).should be_true
#     
#     # check result
#     terminals.size.should == 1
#     terminals[0].statement.should == process.activity("true_activity")
#     
#     # close them all in turn and arbitrary order
#     terminals[0].activity_ended.should be_empty
#     ended?(process_exec, main_exec, terminals).should be_true
#   end
# 
#   it "should implement the enactment contract correctly, on decision_1 (with false)" do
#     process, enacter, process_exec, main_exec, terminals = start_on_decision_1{|e| 
#       e == 'do_it?' ? false : Kernel.eval(e)
#     }
#     
#     # process and activity execution are pending now
#     pending?(process_exec, main_exec, terminals).should be_true
#     
#     # check result
#     terminals.size.should == 1
#     terminals[0].statement.should == process.activity("false_activity")
#     
#     # close them all in turn and arbitrary order
#     terminals[0].activity_ended.should be_empty
#     ended?(process_exec, main_exec, terminals).should be_true
#   end
# 
# end