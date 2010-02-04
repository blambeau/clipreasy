require 'clipreasy'
describe ::CliPrEasy::Engine::Markable do
  
  # Factors a markable object. If a block is given, yields it with the 
  # markable object as first argument. Always returns the markable object.
  def markable
    o = Object.new
    o.extend(::CliPrEasy::Engine::Markable)
    yield o if block_given?
    o
  end
  
  it "should allow marking elements" do
    markable {|m|
      m[:hello] = "world"
      m.has_mark?(:hello).should be_true
      m[:hello].should == 'world'
    }
  end
  
  it "should allow unmarking elements" do
    markable {|m|
      m[:hello] = "world"
      m.remove_mark(:hello)
      m.has_mark?(:hello).should be_false
      m[:hello].should be_nil
    }
  end

  it "should support nil marks" do
    markable {|m|
      m[:hello] = nil
      m.has_mark?(:hello).should be_true
      m[:hello].should be_nil
    }
  end
  
  it "should provide marks as a copy" do
    markable {|m|
      m[:hello] = "world"
      marks = m.marks
      marks.should == {:hello => "world"}  
      marks[:hello] = "world2"
      m[:hello].should == "world"
    }
  end
  
end