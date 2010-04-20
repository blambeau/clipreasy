require 'clipreasy'
describe ::CliPrEasy::Persistence::XML::Decoder do
  include ::CliPrEasy::Fixtures
  
  def decode_file(file)
    ::CliPrEasy::Persistence::XML::Decoder.new.decode_file(file)
  end
  
  it "should decode all fixture examples without raising error" do
    all_process_files do |file|
      p = decode_file(file)
      (::CliPrEasy::Lang::Process === p).should be_true
    end
  end

end