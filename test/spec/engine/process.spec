require File.expand_path('../../../spec_helper', __FILE__)

describe "CliPrEasy::Commands::Engine#process" do
  
  let(:engine) { ::CliPrEasy::Fixtures::work_and_coffee_engine }

  describe "when called on an existing process" do
    subject{ engine.process(:work_and_coffee) }
    it{ should be_kind_of(::CliPrEasy::Lang::Process) }  
  end

  describe "when called on unexisting process" do 
    subject{ proc{ engine.process(:unknown) } }
    it { should raise_error(::CliPrEasy::UnknownProcessError) }
  end
  
end

