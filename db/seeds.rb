# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
if Rails.env != 'production'
  User.create(:login => 'booch', :first_name => 'Craig', :last_name => 'Buchek', :email_address => 'craig@boochtek.com')
  User.create(:login => 'greg', :first_name => 'Greg', :last_name => 'Mattison', :email_address => 'greg.mattison@habanero.com')
  User.create(:login => 'CraigBuchek', :first_name => 'Craig', :last_name => 'Buchek', :email_address => 'craig@boochtek.com')
end
