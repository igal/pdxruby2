# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  filter_parameter_logging :password, :password_confirmation

  if ["production", "preview"].include?(RAILS_ENV)
    include ExceptionNotifiable
    local_addresses.clear
    self.exception_notifiable_silent_exceptions ||= []
    self.exception_notifiable_silent_exceptions << ActionController::InvalidAuthenticityToken if ActionController.const_defined?(:InvalidAuthenticityToken)
  end

protected

  def logged_in?
    return !! current_user
  end
  helper_method :logged_in?

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    begin
      @current_user_session = MemberSession.find
    rescue Exception => e
      # WTF?
      @current_user_session = nil
    end
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to login_path
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to member_path(current_user)
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
end
