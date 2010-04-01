Then /^(?:|I )should(| not| NOT) see my name$/ do |nt|
  Then "I should#{nt} see \"Fake User\""
end

Then /^(?:|I )should(| not| NOT) see my profile$/ do |nt|
  Then "I should#{nt} see \"User Profile\""
end


