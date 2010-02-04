require 'clipreasy'
describe ::CliPrEasy::Persistence::XML::ProcessXMLDecoder do
  include ::CliPrEasy::Fixtures
  
  def decode_file(file)
    ::CliPrEasy::Persistence::XML::ProcessXMLDecoder.decode_file(file)
  end
  
  it "should decode all fixture examples without raising error" do
    all_process_files do |file|
      decode_file(file)
    end
  end
  
  it "should support business_ids" do
    process = decode_file(process_file("work_and_coffee.cpe"))
    process.business_id.should == "work_and_coffee"
  end
  
  it "should support annotations" do
    process = decode_file(process_file("work_and_coffee.cpe"))
    process[:label].should == "Work and Coffee Fixture Process"
    process.has_mark?(:version).should be_true
  end
  
end