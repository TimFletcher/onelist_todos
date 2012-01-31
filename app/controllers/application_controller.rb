class ApplicationController < ActionController::Base
  # before_filter :http_basic_authentication if Rails.env.staging?
  before_filter :require_payment
  protect_from_forgery

  def authenticate
    deny_access unless authenticated_user?
  end

  def authenticated_user?
    !authenticated_user.nil?
  end

  def deny_access
    store_location
    redirect_to log_in_path, :notice => "Please sign in to access this page."
  end

  def redirect_back_or_to(default)
    redirect_to(session[:return_to] || default, :notice => "Logged in!")
    clear_return_to
  end

  def redirect_authenticated_user(redirect=lists_path)
    redirect_to redirect if authenticated_user
  end

  def sign_in(user)
    if params[:forget]
      cookies[:auth_token] = user.auth_token
    else
      cookies.permanent[:auth_token] = user.auth_token
    end
  end

  def sign_out
    cookies.delete(:auth_token)
  end

  def authenticated_user
    @current_user ||= User.where(:auth_token => cookies[:auth_token]).first if cookies[:auth_token] # x = x || y
  end

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_return_to
    session[:return_to] = nil
  end

  def http_basic_authentication
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV['HTTP_BASIC_USERNAME'] && password == ENV['HTTP_BASIC_PASSWORD']
    end
  end

  def deny_access
    store_location
    redirect_to log_in_path, :notice => "Please sign in to access this page."
  end

  def require_payment
    if authenticated_user
      payment_redirect_exemptions = [payment_notifications_new_path,
                                     payment_notifications_path,
                                     log_out_path]
      redirect_to payment_notifications_new_path \
          unless authenticated_user.within_trial? \
          or payment_redirect_exemptions.include? request.fullpath \
          or authenticated_user.paid
    end
  end

  def mobile_device?
    request.user_agent =~ /mobile|Mobile|webOS/
  end

  # Allow helper methods to be used in views
  helper_method :mobile_device?
  helper_method :authenticated_user
end
