require File.expand_path('../../../spec_helper', __FILE__)

describe "CliPrEasy::Commands::Engine#plural_of" do
  
  let(:engine) { ::CliPrEasy::Fixtures::work_and_coffee_engine }

  describe "when called on an existing entity name" do
    subject{ engine.plural_of(:employee) }
    specify{ should == :employees }  
  end
  
  describe "when called on unexisting entity name" do 
    subject{ proc{ engine.plural_of(:unknown) } }
    it { should raise_error(::CliPrEasy::UnknownEntityError) }
  end
  
end

