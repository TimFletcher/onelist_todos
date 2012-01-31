require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  include Rails.application.routes.url_helpers

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end

  test "Sends a password reset email" do
    user = FactoryGirl.create(:user, :password_reset_token => "anything")
    mail = UserMailer.password_reset(user)
    assert_equal "Your password reset on OneList", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["support@onelistapp.co"], mail.from
    assert_match /^To reset your password, click the link below/, mail.body.encoded
    assert_match password_reset_token_url(user.password_reset_token), mail.body.encoded
  end
end
