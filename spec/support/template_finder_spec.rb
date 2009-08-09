require "spec/spec_helper"

describe Riwiki::Support::TemplateFinder do
  
  it { should_not be_nil }
  
  context "included in class" do
    
    before(:each) do
      @m = Object.new
      @m.send :extend, Riwiki::Support::TemplateFinder
      @m.stub!(:controller_path).and_return('my_controller')
    end
    
    specify "should provide template_dir method" do 
      @m.should respond_to :template_dir
    end
    
    specify "should select template at controller_path when exists" do 
      Dir.should_receive(:glob).with("app/views/my_controller/my_template.html.*").and_return(['some_template'])
      
      @m.template_dir('my_template').should == 'my_controller'
    end
    
    specify "should select template in base dir when it doesn't exists at controller_path" do 
      Dir.should_receive(:glob).with("app/views/my_controller/my_template.html.*").and_return([])
      
      @m.template_dir('my_template').should == 'base_wiki_pages'
    end
    
  end
  
end