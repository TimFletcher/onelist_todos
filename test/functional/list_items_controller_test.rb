require 'test_helper'

class ListItemsControllerTest < ActionController::TestCase

  setup :initialise

  test "redirects non-authenticated users" do
    xhr :post, :create, :list_id => @list_item.list.id 
    assert_redirected_to log_in_path
    xhr :put, :update, :id => @list_item.id
    assert_redirected_to log_in_path
    xhr :put, :toggle_checkoff, :id => @list_item.id
    assert_redirected_to log_in_path
    xhr :delete, :destroy, :id => @list_item.id
    assert_redirected_to log_in_path
  end

  test "allows public access to private add pages" do
    get :new_via_hash_token, :hash_token => @list_item.list.hash_token
    assert_response :success
  end
  
  test "private add page has form" do
    get :new_via_hash_token, :hash_token => @list_item.list.hash_token
    assert_select 'form'
  end

  test "creates a new list item" do
    sign_in @list_item.list.user
    assert_difference('ListItem.count', +1) do
      xhr :post, :create, :list_id => @list_item.list.id, :list_item => {:text => 'test'}
    end
  end

  test "updates a list item" do
    sign_in @list_item.list.user
    initial_text = @list_item.text
    xhr :put, :update, :id => @list_item.id, :list_item => { :text => 'New list item text' }
    assert_not_equal initial_text, ListItem.find(@list_item.id).text
  end

  test "toggles an item as checked off" do
    sign_in @list_item.list.user
    initial_value = @list_item.complete
    xhr :put, :toggle_checkoff, :id => @list_item.id
    assert_not_equal initial_value, ListItem.find(@list_item.id).complete
  end

  test "deletes an item" do
    sign_in @list_item.list.user
    assert_difference('ListItem.count', -1) do
      xhr :delete, :destroy, :id => @list_item.id
    end
  end

  private

  def initialise
    @list_item = Factory.create(:list_item)
  end

  def sign_in(user)
    @controller.sign_in user
    @request.cookies[:auth_token] = @request.cookie_jar[:auth_token] # Why?
  end
end
