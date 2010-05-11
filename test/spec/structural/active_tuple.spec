require File.expand_path('../../../spec_helper', __FILE__)

describe "CliPrEasy::Structural::ActiveTuple" do
  
  let(:engine)    { ::CliPrEasy::Fixtures::work_and_coffee_engine }
  subject         { engine.active_tuple(:employee, 1)             }
  
  specify{
    subject.token.should == 1
    subject.name.should == "Lamborgh"
    subject.department.should be_kind_of(CliPrEasy::Structural::ActiveTuple)
    subject.department.name.should == "Computer Science"
  }
  
  specify{
    subject["employee.name"].should == "Lamborgh"
    subject["employee.department.name"].should == "Computer Science"
  }

end

