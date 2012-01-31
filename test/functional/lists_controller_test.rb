require 'test_helper'

class ListsControllerTest < ActionController::TestCase
  
  setup :initialise

  test "redirects non-authenticated users" do
    get :index
    assert_redirected_to log_in_path
    post :create
    assert_redirected_to log_in_path
    get :show, :id => @list.id
    assert_redirected_to log_in_path
    put :update, :id => @list.id
    assert_redirected_to log_in_path
    delete :destroy, :id => @list.id
    assert_redirected_to log_in_path
  end

  test "shows a user's lists" do
    sign_in @user
    get :index
    assert_response :success
    assert_select 'div#content'
    assert_select 'form#new_list'
  end

  test "creates a new list" do
    sign_in @user
    assert_difference('List.count', +1) do
      xhr :post, :create, :list => { :name => 'Some List Name' }
    end
  end

  test "shows a list" do
    sign_in @list.user
    get :show, :id => @list.id
    assert_response :success
    assert_select 'h2', @list.name
  end

  test "updates a list" do
    sign_in @list.user
    new_name = 'A new list name'
    xhr :put, :update, :id => @list.id, :list => { :name => new_name }
    assert_equal new_name, List.find(@list.id).name
  end

  test "destroys a list" do
    sign_in @list.user
    assert_difference('List.count', -1) do
      xhr :delete, :destroy, :id => @list.id
    end
    assert_raise(ActiveRecord::RecordNotFound) do
      List.find(@list.id)
    end
  end

  private

  def initialise
    @user = Factory.create(:user, :email => 'foo@bar.com', :password => 'secret')
    @list = Factory.create(:list)
  end

  def sign_in(user)
    @controller.sign_in user
    #puts @request.cookies[:auth_token] # nil
    #puts @request.cookie_jar[:auth_token] # auth_token
    @request.cookies[:auth_token] = @request.cookie_jar[:auth_token] # Why?
  end
end

