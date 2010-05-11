require File.expand_path('../../../spec_helper', __FILE__)

describe "CliPrEasy::Commands::Engine#candidates" do
  
  let(:engine) { ::CliPrEasy::Fixtures::work_and_coffee_engine }

  describe "when called on a non-referencing attribute" do
    subject{ engine.candidates_for(:employee, :name) }
    specify{ should == [] }  
  end
  
  describe "when called on a referencing attribute" do
    subject{ engine.candidates_for(:employee, :department) }
    specify{ should be_kind_of(::Rubyrel::Relvar) }  
  end
  
  describe "when called on unexisting entity name" do 
    subject{ proc{ engine.candidates_for(:unknown, :unknown) } }
    it { should raise_error(::CliPrEasy::UnknownEntityAttributeError) }
  end
  
end

