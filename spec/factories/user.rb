# Standard user
Factory.define :user do |u|
  u.login         'john_doe'
  u.email_address 'john.doe@example.com'
  u.first_name    'John'
  u.last_name     'Doe'
end

# Admin user
#Factory.define :admin, :class => User do |u|
#  u.login 'admin'
#  u.first_name 'Admin'
#  u.last_name  'User'
#  u.full_name  'Admin User'
#end
