require 'test_helper'

class StaticControllerTest < ActionController::TestCase
  test "shows home page" do
    get :home
    assert_response :success
  end

  test "redirects authenticated users to the lists page" do
    user = Factory.create(:user, :email => 'foo@bar.com', :password => 'secret')
    sign_in user
    get :home
    assert_redirected_to lists_url
  end

  private

  def sign_in(user)
    @controller.sign_in user
    @request.cookies[:auth_token] = @request.cookie_jar[:auth_token] # Why?
  end
end
