require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup :initialise

  test "shows the registration page with a form" do
    get :new
    assert_response :success, "Registration page doesn't work"
    assert_not_nil assigns(:user)
    assert_select 'form'
  end

  test "creates a new user and logs them in" do
    email = 'foo@bar.com'
    assert_difference('User.count', +1) do
      post :create, :user => { :email => email,
                               :password => 'password',
                               :password_confirmation => 'password' }
    end
    assert_redirected_to lists_path
    assert_equal "We've created your account and automatically logged you in.", flash[:notice]
    assert_equal User.find_by_email(email).auth_token, cookies[:auth_token]
  end

  test "shows the password reset page" do
    get :password_reset_form
    assert_response :success, "Password reset page doesn't work"
    assert_select 'form'
  end

  test "shows an error message for a blank email" do
    post :password_reset, :email => ''
    assert_equal "You must supply an email", flash[:notice]
  end

  test "shows an error message for a non-existent email" do
    post :password_reset, :email => 'wrong@email.com'
    assert_equal "There is no user with that email", flash[:notice]
  end

  test "sends a password reset email for a correct email address" do
    post :password_reset, :email => @user.email
    assert_equal @user.email, ActionMailer::Base.deliveries.last['to'].to_s
  end

  test "shows a success page when correctly resetting a password" do
    post :password_reset, :email => @user.email
    assert_template :password_reset_success
  end

  test "logs a user in when correctly resetting a password" do
    @user.send_password_reset
    get :password_reset_token, :token => @user.password_reset_token
    assert_redirected_to lists_path
    assert_equal @controller.authenticated_user, @user
    assert_equal "We've logged you in. Please reset your password!", flash[:notice]
  end

  test "shows an error message for an expired reset" do
    @user.send_password_reset
    @user.update_attribute(:password_reset_sent_at, 3.hours.ago)
    get :password_reset_token, :token => @user.password_reset_token
    assert_equal "Password reset expired", flash[:notice]
    # assert_equal @controller.authenticated_user, @user
    # assert_equal "We've logged you in. Please reset your password!", flash[:notice]
  end

  # Password reset expiry?

  private

  def initialise
    @user = Factory.create(:user)
  end
end
