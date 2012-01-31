require 'integration_test_helper' 

class AddItemPrivateTest < ActionDispatch::IntegrationTest

  def teardown
    Capybara.reset!
  end

  test "login and browse site" do
    login Factory.create(:user)
    assert page.has_content?('Logged in'), 'Has no logged in flash message'
  end
  
  test "add a new list" do
    login Factory.create(:user)
    visit('/lists')
    fill_in('list[name]', :with => 'List Title')
    click_button('Add')
    assert page.has_content?('List Title')
  end
  
  private
  
  def login(user)
    visit('/login')
    assert page.has_content?('Log In'), 'Has no title'
    assert page.has_selector?('form'), 'Has no form'
    fill_in('Email', :with => user.email)
    fill_in('Password', :with => 'secret')
    click_button('Log In')
  end
  
end
