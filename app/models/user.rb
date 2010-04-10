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
  PROHIBITED_USERNAME_REGEX = Regexp.new("(\\A#{PROHIBITED_USERNAMES.join('|')}|\.(#{PROHIBITED_USERNAME_SUFFIXES.join('|')}))\\Z")

  attribute :login,         :string, :required => true, :unique => true, :min_length => 2, :max_length => 50
  attribute :email_address, :string, :required => true, :min_length => 6, :max_length => 100, :format => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  attribute :first_name,    :string, :required => true, :max_length => 50
  attribute :last_name,     :string, :max_length => 50
  attr_accessor :terms_of_service # Note that this is a *virtual* attribute, not in the database. Used for validates_acceptance_of below.
  timestamps

  has_many :accounts, :class_name => 'SocialNetworkAccount' do
    def [](network_name)
      find(:first, :conditions => {:network_name => network_name.to_s.downcase})
    end
  end

  validates_each :login do |record, attr, value|
    record.errors.add attr, 'may only contain alphanumeric characters, plus _ . ! @ -' if value !~ %r{\A[-_.!@[:alnum:]]*\Z}
    record.errors.add attr, 'is not allowed' if value =~ PROHIBITED_USERNAME_REGEX
  end

  validates_uniqueness_of :login, :case_sensitive => false
  validates_acceptance_of :terms_of_service

  after_create :email_user_signup_confirmation

  def full_name
    "#{first_name} #{last_name}"
  end

  def email_user_signup_confirmation
    Notifications.deliver_signup_confirmation(self)
  end

  # We don't support passwords yet, but want to allow entering them on the login form.
  def password
  end
  def password=(val)
  end
  def verify_password(pwd)
    return pwd != 'incorrect password'
  end

  # TODO: Change the login field to username. This is an interim step to allow callers to access either one.
  def username
    self.login
  end

  def follow(user_to_follow)
    # TODO: Add a Following/Connection object, linking the 2. Probably delegate the following line to that object:
    accounts.each{|account| account.follow(user_to_follow.accounts[account.network_name])}
  end
end
