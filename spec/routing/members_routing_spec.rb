require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MembersController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "members", :action => "index").should == "/members"
    end

    it "maps #new" do
      route_for(:controller => "members", :action => "new").should == "/members/new"
    end

    it "maps #show" do
      route_for(:controller => "members", :action => "show", :id => "1").should == "/members/1"
    end

    it "maps #edit" do
      route_for(:controller => "members", :action => "edit", :id => "1").should == "/members/1/edit"
    end

    it "maps #create" do
      route_for(:controller => "members", :action => "create").should == {:path => "/members", :method => :post}
    end

    it "maps #update" do
      route_for(:controller => "members", :action => "update", :id => "1").should == {:path =>"/members/1", :method => :put}
    end

    it "maps #destroy" do
      route_for(:controller => "members", :action => "destroy", :id => "1").should == {:path =>"/members/1", :method => :delete}
    end
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/members").should == {:controller => "members", :action => "index"}
    end

    it "generates params for #new" do
      params_from(:get, "/members/new").should == {:controller => "members", :action => "new"}
    end

    it "generates params for #create" do
      params_from(:post, "/members").should == {:controller => "members", :action => "create"}
    end

    it "generates params for #show" do
      params_from(:get, "/members/1").should == {:controller => "members", :action => "show", :id => "1"}
    end

    it "generates params for #edit" do
      params_from(:get, "/members/1/edit").should == {:controller => "members", :action => "edit", :id => "1"}
    end

    it "generates params for #update" do
      params_from(:put, "/members/1").should == {:controller => "members", :action => "update", :id => "1"}
    end

    it "generates params for #destroy" do
      params_from(:delete, "/members/1").should == {:controller => "members", :action => "destroy", :id => "1"}
    end
  end
end
