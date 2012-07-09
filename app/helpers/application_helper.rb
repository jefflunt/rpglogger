module ApplicationHelper
  def username_for_top_section(user)
    case user.provider
    when "google_oauth2"
      user.nickname
    when "facebook"
      "#{user.nickname}"
    when "twitter"
      "@#{user.nickname}"
    end
  end
end
