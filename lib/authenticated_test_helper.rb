module AuthenticatedTestHelper
  # Sets the current member in the session from the member fixtures.
  def login_as(member)
    identity = \
      case member
      when Member
        member.id
      when String
        members(member.to_sym).id
      when Symbol
        members(member).id
      when Fixnum
        member
      when NilClass
        nil
      else
        raise TypeError, "Can't login as type: #{member.class}"
      end
    request.session[:member] = identity
    controller.instance_variable_set("@current_user_session", OpenStruct.new(:record => Member.find(identity)))
  end

  def authorize_as(member)
    request.env["HTTP_AUTHORIZATION"] = member ? %{Basic #{Base64.encode64("#{members(member).login}:test")}} : nil
  end

  def logout
    if request
      request.session[:member] = nil
      request.env["HTTP_AUTHORIZATION"] = nil
      current_user_session.destroy if defined?(current_user_session)
    end
  end
end
