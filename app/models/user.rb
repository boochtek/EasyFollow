class User < ActiveRecord::Base
  # These usernames cannot be used, because they might be used within the site itself.
  PROHIBITED_USERNAMES = %w[
    admin session login logout signup home profile bio connections connection connect follow follows following followings
    network networks settings search location locations industry industries title titles news site_news contact feedback browse
    stylesheets css styles scripts javascripts js javascript images icons files robots.txt
    about terms legal privacy terms_and_conditions terms_of_service faq faqs
    easyfollow facebook twitter linkedin youtube
  ]
  PROHIBITED_USERNAME_SUFFIXES = %w[html htm php js css ico]
  PROHIBITED_USERNAME_REGEX = Regexp.new("(#{PROHIBITED_USERNAMES.join('|')}|\.(#{PROHIBITED_USERNAME_SUFFIXES.join('|')}))")

  attribute :login,         :string, :required => true, :unique => true, :min_length => 2, :max_length => 50
  attribute :email_address, :string, :required => true, :min_length => 6, :max_length => 100, :format => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  attribute :first_name,    :string, :required => true, :max_length => 50
  attribute :last_name,     :string, :max_length => 50
  attr_accessor :terms_of_service # Note that this is a *virtual* attribute, not in the database. Used for validates_acceptance_of below.
  timestamps

  validates_each :login do |record, attr, value|
    record.errors.add attr, 'may not contain a slash (/)' if value =~ %r{/}
    record.errors.add attr, 'may not contain any whitespace characters' if value =~ %r{\s}
    record.errors.add attr, 'is not allowed' if value =~ PROHIBITED_USERNAME_REGEX
  end

  validates_uniqueness_of :login, :case_sensitive => false
  validates_acceptance_of :terms_of_service

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
