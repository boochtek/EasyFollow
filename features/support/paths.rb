class String
  def trim_quotes
    self[/\A["']*([^"']*)["']*\Z/, 1]
  end
end


module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    return page_name if page_name =~ %r{\A/.*}
    return page_name.trim_quotes if page_name.trim_quotes =~ %r{\A/.*}

    case page_name
    
    when /the home\s?page/, /my profile page/
      '/'
    when /the (contact|feedback) page/
      '/contact'
    when /the login page/
      '/login'
    when /the logout page/
      '/logout'
    when /the signup page/
      '/signup'
    when /the signup2 page/
      '/signup2'
    when /the add Twitter network page/
      '/network/add/twitter'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
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
