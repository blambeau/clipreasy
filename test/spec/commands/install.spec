require File.expand_path('../../../spec_helper', __FILE__)

describe "CliPrEasy::Commands::Install" do

  let(:db_file)    { File.expand_path("../test.db", __FILE__) }
  let(:db_handler) { "sqlite://test.db" }
  let(:command)    { ::CliPrEasy::Commands::Install.new }

  context("Launched without process folder") do
    let(:args) { [db_handler] }
    subject { proc{ FileUtils.rm_rf(db_file); command.run __FILE__, args, STDOUT } }
    
    it { should_not raise_error }
  end

  context("Launches on the work_and_coffee_process") do
    let(:folder) { File.join(::CliPrEasy::Fixtures::fixtures_folder, 'work_and_coffee') }
    let(:args) { ["--process-folder", folder, db_handler] }
    subject { proc{ FileUtils.rm_rf(db_file); command.run __FILE__, args, STDOUT } }
    
    it { should_not raise_error }
    specify {
      db = ::Rubyrel::connect(db_handler)
      db.should respond_to(:work_and_coffee)
      db.namespace(:work_and_coffee, false).should_not be_nil
      db.work_and_coffee.relvar(:clients, false).should_not be_nil
    }
  end

end