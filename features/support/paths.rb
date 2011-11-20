module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in webrat_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /the log_books index/
      log_books_path
    # when /the new portals page/
    #   new_portals_path
    # 
    # when /administrations page/
    #   administrations_path
    # 
    # when /the portal page for code "([^\"]*)"/
    #   "/portals/#{$1}"
    # 
    # when /the participant page for email "([^\"]*)"/
    #   part = Participant.find_by_email($1)
    #   "/participants/#{part.id}"   
 
    # Add more mappings here.
    # Here is a more fancy example:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
