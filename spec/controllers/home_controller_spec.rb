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

  describe "GET spammers_forbidden" do
    describe "reject_spammer" do
      it "should reject a spammer" do
        login_as :spammy

        get :spammers_forbidden

        response.should be_redirect
        flash[:error].should_not be_blank
      end

      it "should not reject a non-spammer" do
        login_as :bubba

        get :spammers_forbidden

        response.should be_success
        flash[:error].should be_blank
      end

      it "should not reject an anonymous user" do
        logout

        get :spammers_forbidden

        response.should be_success
        flash[:error].should be_blank
      end
    end
  end
end

describe HomeController, "helpers" do
  fixtures :members, :locations, :events

  describe "current_user_spammer?" do
    it "should mark a known-spammer as a spammer" do
      login_as :spammy
      controller.send(:current_user_spammer?).should be_true
    end

    it "should not mark a non-spammer as a spammer" do
      login_as :bubba
      controller.send(:current_user_spammer?).should be_false
    end

    it "should not anonymous as a spammer" do
      logout
      controller.send(:current_user_spammer?).should be_false
    end
  end

  describe "logged_in_and_nonspammer?" do
    it "should not give access to spammer" do
      login_as :spammy
      controller.send(:logged_in_and_nonspammer?).should be_false
    end

    it "should give access to logged-in non-spammer" do
      login_as :bubba
      controller.send(:logged_in_and_nonspammer?).should be_true
    end

    it "should not give access to anonymous" do
      logout
      controller.send(:logged_in_and_nonspammer?).should be_false
    end
  end
end
