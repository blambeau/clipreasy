require File.expand_path('../../../spec_helper', __FILE__)

describe "CliPrEasy::Commands::Engine#screen_fields" do
  
  let(:engine) { ::CliPrEasy::Fixtures::work_and_coffee_engine }

  describe "when called on an existing screen" do
    subject{ engine.screen_fields(:start_project) }
    it{ should be_kind_of(::Rubyrel::DerivedRelvar) }  
  end

  describe "when called on a tuple instance" do
    let(:screen) { engine.screen(:start_project) }
    subject{ engine.screen_fields(screen) }
    specify{ should be_kind_of(::Rubyrel::DerivedRelvar) }  
  end
  
  describe "when called on unexisting screen" do 
    subject{ proc{ engine.screen_fields(:unknown) } }
    it { should raise_error(::CliPrEasy::UnknownScreenError) }
  end
  
end

