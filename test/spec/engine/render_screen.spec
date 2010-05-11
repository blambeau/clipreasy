require File.expand_path('../../../spec_helper', __FILE__)

describe "CliPrEasy::Commands::Engine#render_screen" do
  
  let(:engine) { ::CliPrEasy::Fixtures::work_and_coffee_engine }

  describe "when called on an existing screen" do
    subject{ engine.render_screen(:say_hello) }
    
    it { should be_kind_of(String) }  
    it { should =~ /Lamborgh/ }
  end

  describe "when called on unexisting screen" do 
    subject{ proc{ engine.render_screen(:unknown) } }
    
    it { should raise_error(::CliPrEasy::UnknownScreenError) }
  end
  
end

