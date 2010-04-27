require 'clipreasy'
describe ::CliPrEasy::Persistence::Rubyrel do
  include ::CliPrEasy::Fixtures
  
  it 'should provide facade helper to install process schema and processes' do
    db = ::CliPrEasy::Persistence::Rubyrel::install_schema!(pgsql_test_database_handler)
    work_and_coffee_process.save_on_relational_model(db.model, db.schema.namespace(:model))
    
    model = db.model
    model.processes.tuple_count.should == 1
    model.statements.tuple_count.should == work_and_coffee_process.inject(0){|memo,i| memo+1}
    model.decisions.tuple_count.should == work_and_coffee_process.select{|s| ::CliPrEasy::Lang::Decision === s}.size
    model.activities.tuple_count.should == work_and_coffee_process.select{|s| ::CliPrEasy::Lang::Activity === s}.size
    model.untils.tuple_count.should == work_and_coffee_process.select{|s| ::CliPrEasy::Lang::Until === s}.size
    model.whiles.tuple_count.should == work_and_coffee_process.select{|s| ::CliPrEasy::Lang::While === s}.size
    
    rxth_v2_process.save_on_relational_model(db.model, db.schema.namespace(:model))
    model.processes.tuple_count.should == 2
    model.statements.tuple_count.should == work_and_coffee_process.inject(0){|memo,i| memo+1} + rxth_v2_process.inject(0){|memo,i| memo+1}
    
    p = ::CliPrEasy::Lang::process("identifier" => "test") {
      sequence {
        activity('label' => "test_activity_1")
        decision('condition' => "help?") {
          upon('value' => true) {
            activity('label' => "give_help")
          }
          upon('value' => false) {
            activity('label' => "dont_do")
          }          
        }
      }
    }
    p.save_on_relational_model(db.model, db.schema.namespace(:model))
  end
  
  it 'should provide facade helper to reload processes' do 
    db = ::CliPrEasy::Persistence::Rubyrel::install_schema!(pgsql_test_database_handler)
    work_and_coffee_process.save_on_relational_model(db.model, db.schema.namespace(:model))
    copy = ::CliPrEasy::Persistence::Rubyrel::load_process(db, "work_and_coffee")
  end
  
end