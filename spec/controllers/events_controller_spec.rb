require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventsController do
  fixtures :members, :events, :locations

  before(:each) do
    @aaron = members(:aaron)
    @bubba = members(:bubba)
    @clio = members(:clio)
  end

  def mock_event(stubs={})
    defaults = {
      :name => "An event",
      :agenda => "An agenda",
      :starts_at => Time.now,
      :ends_at => Time.now + 2.hours,
      :member => members("aaron"),
      :location => locations("cubespace"),
      :created_at => Time.now,
      :updated_at => Time.now,
      :can_alter? => true,
    }
    @mock_event ||= mock_model(Event, defaults.merge(stubs))
  end

  describe "GET index" do
    it "assigns all events as @events" do
      Event.stub!(:paginate).and_return([mock_event].paginate)
      get :index
      assigns[:events].should == [mock_event].paginate
    end
  end

  describe "GET show" do
    it "assigns the requested event as @event" do
      Event.stub!(:find).with("37").and_return(mock_event)
      get :show, :id => "37"
      assigns[:event].should equal(mock_event)
    end
  end

  describe "GET new" do
    it "shouldn't allow anonymous to create events" do
      get :new
      response.should redirect_to(login_path)
    end

    it "assigns a new event as @event" do
      login_as "aaron"
      Event.stub!(:new).and_return(mock_event)
      get :new
      assigns[:event].should equal(mock_event)
    end
  end

  describe "GET edit" do
    it "shouldn't allow anonymous to create events" do
      get :edit, :id => "37"
      response.should redirect_to(login_path)
    end

    it "assigns the requested event as @event" do
      login_as "aaron"
      Event.stub!(:find).with("37").and_return(mock_event)
      get :edit, :id => "37"
      assigns[:event].should equal(mock_event)
    end
  end

  describe "POST create" do
    it "shouldn't allow anonymous to create events" do
      post :create, :event => {:these => 'params'}
      response.should redirect_to(login_path)
    end

    describe "when logged in" do
      before(:each) do
        login_as "aaron"
      end

      describe "with valid params" do
        it "assigns a newly created event as @event" do
          event = mock_event(:save => true)
          event.should_receive(:member=).with(@aaron)
          Event.stub!(:new).with({'these' => 'params'}).and_return(event)
          post :create, :event => {:these => 'params'}
          assigns[:event].should equal(mock_event)
        end

        it "redirects to the created event" do
          event = mock_event(:save => true)
          Event.stub!(:new).and_return(event)
          event.should_receive(:member=).with(@aaron)
          post :create, :event => {}
          response.should redirect_to(event_url(mock_event))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved event as @event" do
          event = mock_event(:save => false)
          Event.stub!(:new).with({'these' => 'params'}).and_return(event)
          event.should_receive(:member=).with(@aaron)
          post :create, :event => {:these => 'params'}
          assigns[:event].should equal(mock_event)
        end

        it "re-renders the 'new' template" do
          event = mock_event(:save => false)
          event.should_receive(:member=).with(@aaron)
          Event.stub!(:new).and_return(event)
          post :create, :event => {}
          response.should render_template('new')
        end
      end
    end

  end

  describe "PUT update" do
    it "shouldn't allow anonymous to create events" do
      put :update, :id => "37", :event => {:these => 'params'}
      response.should redirect_to(login_path)
    end

    describe "when logged in" do
      before(:each) do
        login_as "aaron"
      end

      describe "with valid params" do
        it "updates the requested event" do
          Event.should_receive(:find).with("37").and_return(mock_event)
          mock_event.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :event => {:these => 'params'}
        end

        it "assigns the requested event as @event" do
          Event.stub!(:find).and_return(mock_event(:update_attributes => true))
          put :update, :id => "1"
          assigns[:event].should equal(mock_event)
        end

        it "redirects to the event" do
          Event.stub!(:find).and_return(mock_event(:update_attributes => true))
          put :update, :id => "1"
          response.should redirect_to(event_url(mock_event))
        end
      end

      describe "with invalid params" do
        it "updates the requested event" do
          Event.should_receive(:find).with("37").and_return(mock_event)
          mock_event.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :event => {:these => 'params'}
        end

        it "assigns the event as @event" do
          Event.stub!(:find).and_return(mock_event(:update_attributes => false))
          put :update, :id => "1"
          assigns[:event].should equal(mock_event)
        end

        it "re-renders the 'edit' template" do
          Event.stub!(:find).and_return(mock_event(:update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end
      end
    end

  end

  describe "DELETE destroy" do
    it "shouldn't allow anonymous to create events" do
      delete :destroy, :id => "37"
      response.should redirect_to(login_path)
    end

    describe "when logged in" do
      before(:each) do
        login_as "aaron"
      end

      it "destroys the requested event" do
        Event.should_receive(:find).with("37").and_return(mock_event(:destroy => true))
        delete :destroy, :id => "37"
      end

      it "redirects to the events list" do
        Event.stub!(:find).and_return(mock_event(:destroy => true))
        delete :destroy, :id => "1"
        response.should redirect_to(events_url)
      end
    end
  end
end
