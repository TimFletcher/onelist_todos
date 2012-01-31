module UsersHelper
  def remove_sensitive_error_messages_from_user(user)
    # How can this be used to remove the digest error message?
    @user.errors.full_messages.delete_if { |msg| msg =~ /digest/ }
  end
end
