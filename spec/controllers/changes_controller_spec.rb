require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ChangesController do

  fixtures :members, :locations, :events

  describe "GET changes" do
    before(:each) do
      @location = Location.create!(:name => "A place", :address => "An address")
      @location.name = "Renamed place"
      @location.save
    end

    it "should display changes" do
      get :show, :format => "html"
      pending "Figure out why /changes isn't rendering in tests"
    end

    it "should display changes feed" do
      get :show, :format => "atom"
      pending "Figure out why /changes isn't rendering in tests"
    end

  end

end
