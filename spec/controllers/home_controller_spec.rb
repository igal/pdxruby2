require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomeController do
  fixtures :members, :locations, :events
  describe "GET index" do
    it "should display page and events" do
      get :index

      events = assigns[:events]
      events.include?(events(:meeting))
      events.include?(events(:meeting2))
    end
  end

  describe "GET changes" do
    before(:each) do
      @location = Location.create!(:name => "A place", :address => "An address")
      @location.name = "Renamed place"
      @location.save
    end

    it "should display changes" do
      get :changes, :format => "html"
      pending "Figure out why /changes isn't rendering in tests"
    end

    it "should display changes feed" do
      get :changes, :format => "atom"
      pending "Figure out why /changes isn't rendering in tests"
    end

  end

end
