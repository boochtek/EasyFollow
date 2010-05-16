class User < ActiveRecord::Base
  # Use Devise for login authentication, password recovery, etc. We're not using Devise for registration/signup.
  devise :authenticatable, :recoverable, :rememberable, :trackable, :validatable, :locakable

  # These usernames cannot be used, because they might be used within the site itself.
  PROHIBITED_USERNAMES = %w[
    users? admin sessions? login logout signup home profiles? bios? connections? connect follows? followings? registrations? passwords?
    networks? settings search locations? industry industries titles? news site_news contact feedback browse
    stylesheets? css styles? scripts? javascripts? js javascript images? icons? files? robots.txt
    about terms legal privacy terms_and_conditions terms_of_service faqs?
    easyfollow facebook twitter linkedin youtube
  ]
  PROHIBITED_USERNAME_SUFFIXES = %w[html htm php js css ico]
  PROHIBITED_USERNAME_REGEX = Regexp.new("\\A(#{PROHIBITED_USERNAMES.join('|')}|.*\\.(#{PROHIBITED_USERNAME_SUFFIXES.join('|')}))\\Z")

  attribute :username,      :string, :required => true, :unique => true, :min_length => 2, :max_length => 50
  attribute :email,         :string, :required => true, :min_length => 6, :max_length => 100, :format => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  attribute :first_name,    :string, :required => true, :max_length => 50
  attribute :last_name,     :string, :max_length => 50
  attr_accessor :terms_of_service # Note that this is a *virtual* attribute, not in the database. Used for validates_acceptance_of below.
  timestamps

  # Only allow users to directly modify these attributes.
  attr_accessible :username, :email, :first_name, :last_name, :password, :password_confirmation

  has_many :accounts, :class_name => 'SocialNetworkAccount' do
    def [](network_name)
      find(:first, :conditions => {:network_name => network_name.to_s})
    end
  end

  has_many :connections, :foreign_key => :follower_id

  validates_each :username do |record, attr, value|
    record.errors.add attr, 'may only contain alphanumeric characters, plus _ . ! @ -' if value !~ %r{\A[-_.!@[:alnum:]]*\Z}
    record.errors.add attr, 'is not allowed' if value =~ PROHIBITED_USERNAME_REGEX
  end

  validates_uniqueness_of :username, :case_sensitive => false
  validates_acceptance_of :terms_of_service
  attr_accessible :terms_of_service # Required for validates_acceptance_of

  # We're not using Devise's confirmable to make users confirm their email addresses. But we're seding them an email telling them that they've signed up.
  after_create :email_user_signup_confirmation

  def email_user_signup_confirmation
    Notifications.deliver_signup_confirmation(self)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.find_first_by_username(username)
    self.find(:first, :conditions => ['LOWER(username) = ?', username.downcase]) # NOTE: It'd be better if we just set the collation on this column in the DB to be case-insensitive.
  end

  def follow(user_to_follow)
    Connection.create(:follower => self, :followee => user_to_follow)
  end

  def following?(user_to_follow)
    connection = Connection.find(:first, :conditions => ['follower_id = ? AND followee_id = ?', self.id, user_to_follow.id])
    return !!connection
  end
end
