require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MemberSessionsController do
  fixtures :members

  before(:each) do
    @admin = members(:aaron)
    @user = members(:bubba)
  end

  describe "login_as another user" do
    it "should succeed for admin" do
      login_as @admin

      post :login, :login_as => @user.id

      flash[:notice].should =~ /success/i
    end

    it "should not succeed for non-admin" do
      login_as @user

      post :login, :login_as => @admin.id

      flash[:error].should =~ /insufficient/i
    end

    it "should not succeed for anonymous" do
      logout

      post :login, :login_as => @admin.id

      flash[:error].should =~ /insufficient/i
    end
  end

end
