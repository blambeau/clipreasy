require File.expand_path('../../../spec_helper', __FILE__)

describe ::CliPrEasy::Enactment::PersistentState do
  include ::CliPrEasy::Fixtures
  
  before(:all) do
    @db = ::CliPrEasy::Persistence::Rubyrel::install_schema!(pgsql_test_database_handler)
    @process = work_and_coffee_process
    @process.save_on_relational_model(@db.model, @db.schema.namespace(:model))
    @db.enactment.process_execution_state = []
    @relvar = @db.enactment.process_execution_state
  end
  
  # Returns an evaluator for this process
  def evaluator
    tired, too_much = nil, true
    Kernel.lambda do |expression, state|
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
  end
  
  it "should support starting processes" do
    state = ::CliPrEasy::Enactment::PersistentState.process_execution(@relvar, @process, evaluator)
    terminals = @process.start(state)
    until terminals.empty?
      terminals = terminals.collect{|t| t.resume}.flatten
    end
  end
  
end