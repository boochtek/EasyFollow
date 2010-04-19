# Define stage for use in main config/deploy.rb file.
set :stage, 'production'
set :rails_env, 'production' # Needed by rake db:migrate in deploy:migrate.

# Set the directory to deploy files to.
# NOTE: This directory will have subdirectories: releases, current (soft link), shared.
set :deploy_to, "/var/www/#{application}/#{stage}"

# Set the roles that each machine will play.
server "#{prod_server}", :app, :web
role :db,  "#{prod_server}", :primary => true

# Set SSH options to use the application account on the server.
ssh_options[:user] = 'meezy'
ssh_options[:port] = 22
# NOTE: Be sure the account on the server has your public keys in its ~/.ssh/authorized_keys file.
