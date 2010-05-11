require File.expand_path('../../../../spec_helper', __FILE__)

describe "CliPrEasy::WebTools::WidgetHelpers#combobox" do
  
  let(:helpers)       { Object.new.extend(CliPrEasy::WebTools::WidgetHelpers) }
  let(:formdata)      { {:the_name => 'clipreasy'} }
  let(:candidates_1)  { [ {:value => 'clipreasy', :label => 'CliPrEasy'}, {:value => 'rubyrel', :label => 'Rubyrel'} ] }
  let(:candidates_2)  { [ {:pkey => 'clipreasy', :name => 'CliPrEasy'}, {:pkey => 'rubyrel', :name => 'Rubyrel'} ] }
  
  context("when called without candidate at all and no option") do
    subject{ helpers.combobox(:the_name, [], formdata) }
    
    it { should == '<select name="the_name"></select>' }
  end
  
  context("when called with some candidates and no option") do
    subject{ helpers.combobox(:the_name, candidates_1, formdata) }
    
    it { should == '<select name="the_name"><option value="clipreasy" selected="selected">CliPrEasy</option><option value="rubyrel">Rubyrel</option></select>' }
  end
  
  context("when called with some candidates and rewriting options") do
    subject{ helpers.combobox(:the_name, candidates_2, formdata, {:value => :pkey, :label => :name}) }
    
    it { should == '<select name="the_name"><option value="clipreasy" selected="selected">CliPrEasy</option><option value="rubyrel">Rubyrel</option></select>' }
  end
  
  context("when called without candidate at all and the with_none option") do
    subject{ helpers.combobox(:the_name, [], formdata, :with_none => true) }
    
    it { should == '<select name="the_name"><option value=""></option></select>' }
  end
  
end