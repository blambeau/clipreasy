require File.expand_path('../../../spec_helper', __FILE__)

describe ::CliPrEasy::Lang::Forall do
  include ::CliPrEasy::Fixtures
  
  context "when decoding forall.cpe" do
    subject{ process('forall').main }
    it { should be_kind_of(::CliPrEasy::Lang::Forall) }
  end

end