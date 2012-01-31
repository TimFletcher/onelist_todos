require 'test_helper'

class UserTest < ActiveSupport::TestCase

  setup :initialise

  test "Cannot mass assign to protected fields" do
    user = User.new(:email => 'foo@bar.com',
                    :password => 'secret',
                    :password_confirmation => 'secret',
                    :auth_token => 'foo',
                    :password_reset_token => 'foo')
    assert_nil user.auth_token, "password_reset_token was assigned a value"
    assert_nil user.password_reset_token, "password_reset_token was assigned a value"
    assert_not_nil user.email, "Email wasn't assigned a value"
  end

  test "User is not valid without an email" do
    @user_unsaved.email = nil
    assert_raise(ActiveRecord::RecordInvalid) do
      @user_unsaved.save!
    end
  end

  test "User is not valid without a unique email" do
    FactoryGirl.create(:user, :email => "foo@example.com")
    assert_raise(ActiveRecord::RecordInvalid) do
      FactoryGirl.create(:user, :email => "foo@example.com")
    end
  end

  test "User is not valid without a password" do
    @user_unsaved.password = nil
    assert_raise(ActiveRecord::RecordInvalid) do
      @user_unsaved.save!
    end
  end

  test "User is not valid without a password confirmation" do
    @user_unsaved.password_confirmation = nil
    assert_raise(ActiveRecord::RecordInvalid) do
      @user_unsaved.save!
    end
  end

  test "Generates a token" do
    assert_not_nil @user.auth_token
  end

  test "Generates a unique token" do
    @user.generate_token('password_reset_token')
    assert_not_equal @user.auth_token, @user.password_reset_token
  end

  test "Saves the time the password reset was sent" do
    @user.send_password_reset
    assert_not_nil @user.password_reset_sent_at
  end

  test "Password reset email sent to correct user" do
    @user.send_password_reset
    assert_match @user.email, ActionMailer::Base.deliveries.last['to'].to_s
  end

  private

  def initialise
    @user = FactoryGirl.create(:user)
    @user_unsaved = FactoryGirl.build(:user)
  end
end

