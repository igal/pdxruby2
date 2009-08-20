require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LocationsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "locations", :action => "index").should == "/locations"
    end

    it "maps #new" do
      route_for(:controller => "locations", :action => "new").should == "/locations/new"
    end

    it "maps #show" do
      route_for(:controller => "locations", :action => "show", :id => "1").should == "/locations/1"
    end

    it "maps #edit" do
      route_for(:controller => "locations", :action => "edit", :id => "1").should == "/locations/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "locations", :action => "create").should == {:path => "/locations", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "locations", :action => "update", :id => "1").should == {:path =>"/locations/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "locations", :action => "destroy", :id => "1").should == {:path =>"/locations/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/locations").should == {:controller => "locations", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/locations/new").should == {:controller => "locations", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/locations").should == {:controller => "locations", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/locations/1").should == {:controller => "locations", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/locations/1/edit").should == {:controller => "locations", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/locations/1").should == {:controller => "locations", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/locations/1").should == {:controller => "locations", :action => "destroy", :id => "1"}
    end
  end
end
