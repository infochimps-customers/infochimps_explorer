require 'spec_helper'
describe ProtocolsController do
  
  before(:each) do
    begin
      @dataset           = Dataset.make 
    rescue => e
      puts "#{e.class} -- #{e.message}"
      puts e.backtrace
      raise
    end
    @user              = User.make
    @admin             = User.make(:admin)
  end

  describe "documentation" do
    before do
      get :documentation, :slug => @dataset.cached_slug, :format => :esi
    end
    it "should set @dataset based on the slug" do
      assigns[:dataset].should == @dataset
    end
    it "should set @icss to the icss of the dataset" do
      assigns[:icss].should == @dataset.icss
    end
    it "should render the documentation template" do
      response.should render_template("protocols/documentation")
    end
  end
  
  describe "explorer" do
    before do
      get :explorer, :slug => @dataset.cached_slug, :format => :esi
    end
    it "should set @dataset based on the slug" do
      assigns[:dataset].should == @dataset
    end
    it "should set @icss to the icss of the dataset" do
      assigns[:icss].should == @dataset.icss
    end
    it "should render the explorer template" do
      response.should render_template("protocols/explorer")
    end
  end
end
