require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LocationsController do
  fixtures :members

  def mock_location(stubs={})
    defaults = {
      :name => "A place",
      :address => "An address",
      :can_alter? => true,
    }
    @mock_location ||= mock_model(Location, defaults.merge(stubs))
  end

  describe "GET index" do
    it "assigns all locations as @locations" do
      Location.stub!(:find).with(:all).and_return([mock_location])
      get :index
      assigns[:locations].should == [mock_location]
    end
  end

  describe "GET show" do
    it "assigns the requested location as @location" do
      Location.stub!(:find).with("37").and_return(mock_location)
      get :show, :id => "37"
      assigns[:location].should equal(mock_location)
    end
  end

  describe "GET new" do
    it "shouldn't allow anonymous to create locations" do
      get :new
      response.should redirect_to(login_path)
    end

    it "assigns a new location as @location" do
      login_as "aaron"
      Location.stub!(:new).and_return(mock_location)
      get :new
      assigns[:location].should equal(mock_location)
    end
  end

  describe "GET edit" do
    it "shouldn't allow anonymous to edit locations" do
      get :edit, :id => "37"
      response.should redirect_to(login_path)
    end

    it "assigns the requested location as @location" do
      login_as "aaron"
      Location.stub!(:find).with("37").and_return(mock_location)
      get :edit, :id => "37"
      assigns[:location].should equal(mock_location)
    end
  end

  describe "POST create" do
    it "shouldn't allow anonymous to create locations" do
      post :create, :location => {:these => 'params'}
      response.should redirect_to(login_path)
    end

    describe "when logged in" do
      before(:each) do
        login_as "aaron"
      end

      describe "with valid params" do
        it "assigns a newly created location as @location" do
          Location.stub!(:new).with({'these' => 'params'}).and_return(mock_location(:save => true))
          post :create, :location => {:these => 'params'}
          assigns[:location].should equal(mock_location)
        end

        it "redirects to the created location" do
          Location.stub!(:new).and_return(mock_location(:save => true))
          post :create, :location => {}
          response.should redirect_to(location_url(mock_location))
        end
      end

      describe "with invalid params" do
        it "assigns a newly created but unsaved location as @location" do
          Location.stub!(:new).with({'these' => 'params'}).and_return(mock_location(:save => false))
          post :create, :location => {:these => 'params'}
          assigns[:location].should equal(mock_location)
        end

        it "re-renders the 'new' template" do
          Location.stub!(:new).and_return(mock_location(:save => false))
          post :create, :location => {}
          response.should render_template('new')
        end
      end
    end
  end

  describe "PUT update" do
    describe "when logged in" do
      before(:each) do
        login_as "aaron"
      end

      describe "with valid params" do
        it "updates the requested location" do
          Location.should_receive(:find).with("37").and_return(mock_location)
          mock_location.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :location => {:these => 'params'}
        end

        it "assigns the requested location as @location" do
          Location.stub!(:find).and_return(mock_location(:update_attributes => true))
          put :update, :id => "1"
          assigns[:location].should equal(mock_location)
        end

        it "redirects to the location" do
          Location.stub!(:find).and_return(mock_location(:update_attributes => true))
          put :update, :id => "1"
          response.should redirect_to(location_url(mock_location))
        end
      end

      describe "with invalid params" do
        it "updates the requested location" do
          Location.should_receive(:find).with("37").and_return(mock_location)
          mock_location.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, :id => "37", :location => {:these => 'params'}
        end

        it "assigns the location as @location" do
          Location.stub!(:find).and_return(mock_location(:update_attributes => false))
          put :update, :id => "1"
          assigns[:location].should equal(mock_location)
        end

        it "re-renders the 'edit' template" do
          Location.stub!(:find).and_return(mock_location(:update_attributes => false))
          put :update, :id => "1"
          response.should render_template('edit')
        end
      end
    end

  end

  describe "DELETE destroy" do
    describe "when logged in" do
      before(:each) do
        login_as "aaron"
      end

      it "destroys the requested location" do
        Location.should_receive(:find).with("37").and_return(mock_location)
        mock_location.should_receive(:destroy)
        delete :destroy, :id => "37"
      end

      it "redirects to the locations list" do
        Location.stub!(:find).and_return(mock_location(:destroy => true))
        delete :destroy, :id => "1"
        response.should redirect_to(locations_url)
      end
    end
  end

end
