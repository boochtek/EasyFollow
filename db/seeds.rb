# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
if Rails.env != 'production'
  User.create(:username => 'booch', :first_name => 'Craig', :last_name => 'Buchek', :email => 'craig@boochtek.com', :password => 'craigbuchek')
  User.create(:username => 'greg', :first_name => 'Greg', :last_name => 'Mattison', :email => 'greg.mattison@habanero.com', :password => 'habanero')
  User.create(:username => 'CraigBuchek', :first_name => 'Craig', :last_name => 'Buchek', :email => 'craig2@boochtek.com', :password => 'boochtek', :password_confirmation => 'boochtek')
end
