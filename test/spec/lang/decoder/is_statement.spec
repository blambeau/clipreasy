require File.expand_path('../../../../spec_helper', __FILE__)

describe "::CliPrEasy::Lang::Decoder#is_statement?" do
  
  let(:decoder) { ::CliPrEasy::Lang::Decoder.new }
  
  ::CliPrEasy::Lang::Decoder::STATEMENTS.each do |s|
    subject{decoder.is_statement?(s)}
    it { should be_true }
  end
  
end
