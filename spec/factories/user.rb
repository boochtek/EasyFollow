# Standard user
Factory.define :user do |u|
  u.username      'john_doe'
  u.password      'my_Passw0rd'
  u.email         'john.doe@example.com'
  u.first_name    'John'
  u.last_name     'Doe'
end

# Another user
Factory.define :user2, :class => User do |u|
  u.username      'john_smith'
  u.password      'my_Passw0rd'
  u.email         'john.smith@example.com'
  u.first_name    'John'
  u.last_name     'Smith'
end

# Admin user
#Factory.define :admin, :class => User do |u|
#  u.username   'admin'
#  u.password      'my_Passw0rd'
#  u.email      'admin@example.com'
#  u.first_name 'Admin'
#  u.last_name  'User'
#end
