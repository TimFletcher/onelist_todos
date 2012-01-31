class UsersController < ApplicationController

  authentication_required = [:password_change_form, :password_change]
  
  before_filter :redirect_authenticated_user, :except => authentication_required
  before_filter :authenticate, :only => authentication_required
  respond_to :html

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      UserMailer.new_user_signup(@user).deliver
      redirect_to lists_path, :notice => "Account created. Welcome!"
      return
    end
    respond_with(@user) # Understand why I need this - Does this render only the template or the entire new action on errors?
  end

  def password_reset_form
  end

  def password_reset
    user = User.find_by_email(params[:email])
    if params[:email].empty?
      redirect_to password_reset_path, :notice => "You must supply an email"
    else
      if user.nil?
        redirect_to password_reset_path, :notice => "There is no user with that email"
      else
        user.send_password_reset
        render :password_reset_successful
      end
    end
  end

  def password_reset_token
    user = User.find_by_password_reset_token!(params[:token])
    if user.password_reset_sent_at < 2.hours.ago
      redirect_to password_reset_form_path, :notice => "Password reset expired"
    else
      sign_in user
      redirect_to lists_path, :notice => "We've logged you in. Please reset your password!"
    end
  end
  
  def password_change_form
  end

  def password_change
    if params[:user][:password].empty? or params[:user][:password_confirmation].empty?
      redirect_to password_change_path, :notice => "You must supply both passwords"
    elsif params[:user][:password] != params[:user][:password_confirmation]
      redirect_to password_change_path, :notice => "Your passwords must match"
    else
      @current_user.update_attributes(params[:user])
      redirect_to lists_path, :notice => "Password successfully updated"
    end
  end
end
