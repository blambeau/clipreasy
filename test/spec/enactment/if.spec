# require 'clipreasy'
# describe ::CliPrEasy::Enactment::If do
#   include ::CliPrEasy::Fixtures
#   
#   def start_on_if_1(&block)
#     process = process('if_1')
#     enacter = memory_enacter(&block)
#     process_exec, terminals = enacter.start_execution(process)
#     main_exec = process_exec.main_execution
#     [process, enacter, process_exec, main_exec, terminals]
#   end
#   
#   def start_on_if_2(&block)
#     process = process('if_2')
#     enacter = memory_enacter(&block)
#     process_exec, terminals = enacter.start_execution(process)
#     main_exec = process_exec.main_execution
#     [process, enacter, process_exec, main_exec, terminals]
#   end
#   
#   it "should implement the enactment contract correctly, on if_1 (with true)" do
#     process, enacter, process_exec, main_exec, terminals = start_on_if_1{|e| 
#       e == 'do_it?' ? true : Kernel.eval(e)
#     }
#     
#     # process and activity execution are pending now
#     pending?(process_exec, main_exec, terminals).should be_true
#     
#     # check result
#     terminals.size.should == 1
#     terminals[0].statement.should == process.activity("then_activity")
#     
#     # close them all in turn and arbitrary order
#     terminals[0].activity_ended.should be_empty
#     ended?(process_exec, main_exec, terminals).should be_true
#   end
# 
#   it "should implement the enactment contract correctly, on if_1 (with false)" do
#     process, enacter, process_exec, main_exec, terminals = start_on_if_1{|e| 
#       e == 'do_it?' ? false : Kernel.eval(e)
#     }
#     
#     # process and activity execution are pending now
#     pending?(process_exec, main_exec, terminals).should be_true
#     
#     # check result
#     terminals.size.should == 1
#     terminals[0].statement.should == process.activity("else_activity")
#     
#     # close them all in turn and arbitrary order
#     terminals[0].activity_ended.should be_empty
#     ended?(process_exec, main_exec, terminals).should be_true
#   end
# 
#   it "should implement the enactment contract correctly, on if_2 (with true)" do
#     process, enacter, process_exec, main_exec, terminals = start_on_if_2{|e| 
#       e == 'do_it?' ? true : Kernel.eval(e)
#     }
#     
#     # process and activity execution are pending now
#     pending?(process_exec, main_exec, terminals).should be_true
#     
#     # check result
#     terminals.size.should == 1
#     terminals[0].statement.should == process.activity("then_activity")
#     
#     # close them all in turn and arbitrary order
#     terminals[0].activity_ended.should be_empty
#     ended?(process_exec, main_exec, terminals).should be_true
#   end
# 
#   it "should implement the enactment contract correctly, on if_2 (with false)" do
#     process, enacter, process_exec, main_exec, terminals = start_on_if_2{|e| 
#       e == 'do_it?' ? false : Kernel.eval(e)
#     }
#     
#     # process and activity execution are pending now
#     pending?(process_exec, main_exec, terminals).should be_false
#     
#     # check result
#     terminals.size.should == 0
#   end
# 
# end