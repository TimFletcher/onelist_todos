require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  setup :initialise

  test "Shows the login page" do
    get :new
    assert_response :success, "Login page doesn't work"
    assert_select 'form'
  end

  test "Denies access with missing email" do
    post :create, :session => { :email => '', :password => 'secret' }
    assert_template 'new'
  end

  test "Denies access with missing password" do
    post :create, :session => { :email => @user.email, :password => '' }
    assert_template 'new'
  end

  test "Denies access with incorrect email" do
    post :create, :session => { :email => 'wrong@wrong.com', :password => 'secret' }
    assert_template 'new'
  end

  test "Denies access with incorrect password" do
    post :create, :session => { :email => @user.email, :password => 'wrong' }
    assert_template 'new'
  end

  test "Denies access with missing password and email" do
    post :create, :session => { :email => '', :password => '' }
    assert_template 'new'
  end

  test "Allows access with valid credentials" do
    post :create, :session => { :email => @user.email, :password => @user.password }
    assert_equal @controller.authenticated_user, @user
    assert_equal @response.cookies['auth_token'], @request.cookie_jar[:auth_token]
    assert_match /^Logged in/, flash[:notice]
    assert_redirected_to lists_url
  end

  test "Logs a user out properly" do
    @controller.sign_in @user
    get :destroy
    assert_nil @request.cookie_jar[:auth_token]
    assert_equal @controller.authenticated_user?, false
    assert_redirected_to root_url
    assert_match /^Logged out/, flash[:notice]
  end

  private

  def initialise
    @user = Factory.create(:user, :email => 'foo@bar.com', :password => 'secret')
  end
end
