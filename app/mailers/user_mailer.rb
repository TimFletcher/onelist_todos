class UserMailer < ActionMailer::Base
  default :from => "support@onelistapp.co"

  def password_reset(user)
    @user = user
    mail(:to => user.email, :subject => "Your password reset on OneList")
  end

  def new_user_signup(user)
    @user = user
    p user.to_yaml
    mail(:to => OneListRails::Application.config.admin_email,
         :subject => "#{user.email} signed up on OneList")
  end
end
