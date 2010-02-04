require 'clipreasy'
describe ::CliPrEasy do
  include ::CliPrEasy::Fixtures
  
  it "should correctly install the default plugins, basically" do
    ::CliPrEasy::Model::Activity.new.respond_to?(:start).should be_true
  end
  
  it "should correctly install the default plugins, in depth" do
    work_and_coffee_process.each do |s|
      s.respond_to?(:start).should be_true
      s.respond_to?(:ended).should be_true
      s.respond_to?(:close).should(be_true) if CliPrEasy::Model::Activity === s
    end
  end
  
end