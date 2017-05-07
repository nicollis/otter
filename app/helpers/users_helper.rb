module UsersHelper
  def gravatar_for(user, size: 80)
    url = "https://secure.gravatar.com/avatar/#{Digest::MD5::hexdigest(user.email)}?s=#{size}"
    image_tag url, alt: user.name, class: "gravatar"
  end
end
