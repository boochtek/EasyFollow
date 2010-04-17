Then /^(?:|I )should(| not| NOT) see my name$/ do |nt|
  user = @integration_session.controller.current_user
  Then %{I should#{nt} see "#{user.full_name}"}
end

Then /^(?:|I )should(| not| NOT) see my profile$/ do |nt|
  Then %{I should#{nt} see "User Profile"}
end


