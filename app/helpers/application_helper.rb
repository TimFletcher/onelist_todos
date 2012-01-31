module ApplicationHelper

  def title(page_title)
    content_for(:title) { page_title }
  end

  def flash_message_set?
    flash_set = false
    [ :error, :notice, :message ].each do |key|
      flash_set = true unless flash[key].blank?
    end
    return flash_set
  end

  def avatar_url(user, size=50)
    #default_url = "#{root_url}"
    default_url = "#{root_url}assets/icon-avatar.png"
    gravatar_id = Digest::MD5.hexdigest(user.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=#{size}&d=#{CGI.escape(default_url)}"
  end
end
