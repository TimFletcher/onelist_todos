module SessionsHelper

  # def sign_in(user)
  #   # Look into signed cookies here - cookies.permanent.signed[:remember_token] = [user.id, user.salt]
  #   cookies[:user_id] = user
  #   # This is an assignment. The private method current_user= handles this.
  #   self.current_user = user
  # end

  # def sign_out
  #   cookies.delete(:remember_token)
  #   self.current_user = nil
  # end

  # def authenticate
  #   deny_access unless signed_in?
  # end

  # def deny_access
  #   store_location
  #   redirect_to log_in_path, :notice => "Please sign in to access this page."
  # end

  # def current_user
  #   @current_user ||= user_from_remember_token
  # end

  # private

  #   def user_from_remember_token
  #     User.authenticate_with_salt(*remember_token)
  #   end
  # 
  #   def remember_token
  #     cookies.signed[:remember_token] || [nil, nil]
  #   end
  # 
    # def signed_in?
    #   # !current_user.nil?
    #   cookies[:user_id]
    # end
    # 
    # def current_user=(user)
    #   @current_user = user
    # end
  # 
  #   def store_location
  #     session[:return_to] = request.fullpath
  #   end
end
