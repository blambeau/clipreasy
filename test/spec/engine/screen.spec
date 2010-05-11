require File.expand_path('../../../spec_helper', __FILE__)

describe "CliPrEasy::Commands::Engine#screen" do
  
  let(:engine) { ::CliPrEasy::Fixtures::work_and_coffee_engine }

  describe "when called on an existing screen" do
    subject{ engine.screen(:start_project) }
    specify{ should be_kind_of(::Rubyrel::Tuple) }  
  end

  describe "when called on a tuple instance" do
    let(:screen) { engine.screen(:start_project) }
    subject{ engine.screen(screen) }
    specify{ should == screen }  
  end
  
  describe "when called on unexisting screen" do 
    subject{ proc{ engine.screen(:unknown) } }
    it { should raise_error(::CliPrEasy::UnknownScreenError) }
  end
  
end

