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

end
