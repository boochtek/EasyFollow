class User < ActiveRecord::Base
  attribute :login,         :string, :required => true, :unique => true, :min_length => 2, :max_length => 50
  attribute :email_address, :string, :required => true, :min_length => 6, :max_length => 100, :format => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  attribute :first_name,    :string, :required => true, :max_length => 50
  attribute :last_name,     :string, :max_length => 50
  timestamps

  def full_name
    "#{first_name} #{last_name}"
  end

  # We don't support passwords yet, but want to allow entering them on the login form.
  def password
  end
  def password=(val)
  end
  def verify_password(pwd)
    return pwd != 'incorrect password'
  end
end
