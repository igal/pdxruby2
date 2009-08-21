require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MembersController do
  fixtures :members

  before(:each) do
    @aaron = members("aaron")
    @clio = members("clio")
  end

  def mock_member(stubs={})
    defaults = {
      :name => "A name",
      :email => "email@host.com",
      :can_alter? => true,
    }
    @mock_member ||= mock_model(Member, defaults.merge(stubs))
  end

  describe "GET index" do
    it "assigns all members as @members" do
      Member.stub!(:find).with(:all).and_return([mock_member])
      get :index
      assigns[:members].__materialize.should == [mock_member]
    end
  end

  describe "GET show" do
    it "assigns the requested member as @member" do
      Member.stub!(:find).with("37").and_return(mock_member)
      get :show, :id => "37"
      assigns[:member].should equal(mock_member)
    end
  end

  describe "GET new" do
    it "assigns a new member as @member" do
      Member.stub!(:new).and_return(mock_member)
      get :new
      assigns[:member].should equal(mock_member)
    end
  end

  describe "GET edit" do
    it "should not allow anonymous access" do
      get :edit, :id => "37"
      response.should redirect_to(login_path)
    end

    it "should not allow other members access" do
      login_as "clio"
      get :edit, :id => @aaron.id.to_s
      response.should redirect_to(member_path(@aaron))
    end

    it "assigns the requested member as @member" do
      login_as "aaron"
      Member.stub!(:find).with("37").and_return(mock_member)
      get :edit, :id => "37"
      assigns[:member].should equal(mock_member)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created member as @member" do
        Member.stub!(:new).with({'these' => 'params'}).and_return(mock_member(:save => true, :password= => true))
        post :create, :member => {:these => 'params'}
        assigns[:member].should equal(mock_member)
      end

      it "redirects to the created member" do
        Member.stub!(:new).and_return(mock_member(:save => true, :password= => true))
        post :create, :member => {}
        response.should redirect_to(member_url(mock_member))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved member as @member" do
        Member.stub!(:new).with({'these' => 'params'}).and_return(mock_member(:save => false, :password= => true))
        post :create, :member => {:these => 'params'}
        assigns[:member].should equal(mock_member)
      end

      it "re-renders the 'new' template" do
        Member.stub!(:new).and_return(mock_member(:save => false, :password= => true))
        post :create, :member => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do
    it "should not allow anonymous access" do
      put :update, :id => "37", :member => {:these => 'params'}
      response.should redirect_to(login_path)
    end

    it "should not allow other members access" do
      login_as "clio"
      put :update, :id => @aaron.id.to_s, :member => {:these => 'params'}
      response.should redirect_to(member_path(@aaron))
    end

    describe "when logged in" do
      before(:each) do
        login_as "aaron"
      end

      describe "with valid params" do
        before(:each) do
          Member.should_receive(:find).with(@aaron.id.to_s).and_return(@aaron)
          @aaron.should_receive(:update_attributes).with({'these' => 'params'}).and_return(true)
          put :update, :id => @aaron.id.to_s, :member => {:these => 'params'}
        end

        it "assigns the requested member as @member" do
          assigns[:member].should equal(@aaron)
        end

        it "redirects to the member" do
          response.should redirect_to(member_path(@aaron))
        end
      end

      describe "with invalid params" do
        before(:each) do
          Member.should_receive(:find).with(@aaron.id.to_s).and_return(@aaron)
          @aaron.should_receive(:update_attributes).with({'these' => 'params'}).and_return(false)
          put :update, :id => @aaron.id.to_s, :member => {:these => 'params'}
        end

        it "assigns the member as @member" do
          assigns[:member].should equal(@aaron)
        end

        it "re-renders the 'edit' template" do
          response.should render_template('edit')
        end
      end
    end
  end

  describe "DELETE destroy" do
    it "should not allow anonymous access" do
      delete :destroy, :id => @aaron.id.to_s
      response.should redirect_to(login_path)
    end

    it "should not allow other members access" do
      login_as "clio"
      delete :destroy, :id => @aaron.id.to_s
      response.should redirect_to(member_path(@aaron))
    end

    describe "when logged in" do
      before(:each) do
        login_as "aaron"
      end

      it "destroys the requested member" do
        Member.should_receive(:find).with(@aaron.id.to_s).and_return(@aaron)
        @aaron.should_receive(:destroy)
        delete :destroy, :id => @aaron.id.to_s
      end

      it "redirects to the members list" do
        Member.should_receive(:find).with(@aaron.id.to_s).and_return(@aaron)
        @aaron.should_receive(:destroy).and_return(true)
        delete :destroy, :id => @aaron.id.to_s
        response.should redirect_to(members_url)
      end
    end
  end

end
