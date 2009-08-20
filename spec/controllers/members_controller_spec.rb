require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MembersController do

  def mock_member(stubs={})
    @mock_member ||= mock_model(Member, stubs)
  end

  describe "GET index" do
    it "assigns all members as @members" do
      Member.stub!(:find).with(:all).and_return([mock_member])
      get :index
      assigns[:members].should == [mock_member]
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
    it "assigns the requested member as @member" do
      Member.stub!(:find).with("37").and_return(mock_member)
      get :edit, :id => "37"
      assigns[:member].should equal(mock_member)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created member as @member" do
        Member.stub!(:new).with({'these' => 'params'}).and_return(mock_member(:save => true))
        post :create, :member => {:these => 'params'}
        assigns[:member].should equal(mock_member)
      end

      it "redirects to the created member" do
        Member.stub!(:new).and_return(mock_member(:save => true))
        post :create, :member => {}
        response.should redirect_to(member_url(mock_member))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved member as @member" do
        Member.stub!(:new).with({'these' => 'params'}).and_return(mock_member(:save => false))
        post :create, :member => {:these => 'params'}
        assigns[:member].should equal(mock_member)
      end

      it "re-renders the 'new' template" do
        Member.stub!(:new).and_return(mock_member(:save => false))
        post :create, :member => {}
        response.should render_template('new')
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested member" do
        Member.should_receive(:find).with("37").and_return(mock_member)
        mock_member.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :member => {:these => 'params'}
      end

      it "assigns the requested member as @member" do
        Member.stub!(:find).and_return(mock_member(:update_attributes => true))
        put :update, :id => "1"
        assigns[:member].should equal(mock_member)
      end

      it "redirects to the member" do
        Member.stub!(:find).and_return(mock_member(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(member_url(mock_member))
      end
    end

    describe "with invalid params" do
      it "updates the requested member" do
        Member.should_receive(:find).with("37").and_return(mock_member)
        mock_member.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :member => {:these => 'params'}
      end

      it "assigns the member as @member" do
        Member.stub!(:find).and_return(mock_member(:update_attributes => false))
        put :update, :id => "1"
        assigns[:member].should equal(mock_member)
      end

      it "re-renders the 'edit' template" do
        Member.stub!(:find).and_return(mock_member(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested member" do
      Member.should_receive(:find).with("37").and_return(mock_member)
      mock_member.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the members list" do
      Member.stub!(:find).and_return(mock_member(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(members_url)
    end
  end

end
