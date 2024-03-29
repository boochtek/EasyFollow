class User < ActiveRecord::Base
  # Use Devise for login authentication, password recovery, etc. We're not using Devise for registration/signup.
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :lockable

  # These usernames cannot be used, because they might be used within the site itself.
  PROHIBITED_USERNAMES = %w[
    users? admin sessions? login logout signup[123]? home profiles? bios? connections? connect follows? followings? registrations? passwords?
    networks? settings search locations? industry industries titles? news site_news contact feedback browse
    edit new add oauth index update create delete destroy show
    stylesheets? css styles? scripts? javascripts? js javascript images? icons? files? robots.txt
    about terms legal privacy terms_and_conditions terms_of_service faqs?
    easyfollow facebook twitter linkedin youtube
  ]
  PROHIBITED_USERNAME_SUFFIXES = %w[html htm php js css ico]
  PROHIBITED_USERNAME_REGEX = Regexp.new("\\A(#{PROHIBITED_USERNAMES.join('|')}|.*\\.(#{PROHIBITED_USERNAME_SUFFIXES.join('|')}))\\Z")

  attribute :username,      :string, :required => true, :unique => true, :min_length => 2, :max_length => 50
  attribute :email,         :string, :required => true, :min_length => 6, :max_length => 100 # NOTE: Devise includes a format validation for email address, so don't create a duplicate error message.
  attribute :first_name,    :string, :required => true, :max_length => 50
  attribute :last_name,     :string, :max_length => 50
  attr_accessor :terms_of_service # Note that this is a *virtual* attribute, not in the database. Used for validates_acceptance_of below.
  timestamps

  # Only allow users to directly modify these attributes.
  attr_accessible :username, :email, :first_name, :last_name, :password, :password_confirmation

  has_one :bio
  has_many :connections, :foreign_key => :follower_id
  has_many :accounts, :class_name => 'SocialNetworkAccount' do
    def [](network_name)
      find(:first, :conditions => {:network_name => network_name.to_s})
    end
  end

  delegate :location, :title, :industry, :description, :to => '(bio or return nil)'

  def picture
    bio ? bio.picture : Bio::DEFAULT_PICTURE
  end
  def thumbnail
    bio ? bio.thumbnail : Bio::DEFAULT_THUMBNAIL
  end

  validates_each :username do |record, attr, value|
    record.errors.add attr, 'may not contain spaces' if value =~ %r{[[:space:]]}
    record.errors.add attr, 'may only contain alphanumeric characters, plus _ . ! @ -' if value !~ %r{\A[-_.!@[:space:][:alnum:]]*\Z} # NOTE: We include space in here, because we only want the previous error to show up.
    record.errors.add attr, 'is not allowed' if value =~ PROHIBITED_USERNAME_REGEX
  end

  validates_uniqueness_of :username, :case_sensitive => false
  validates_acceptance_of :terms_of_service
  attr_accessible :terms_of_service # Required for validates_acceptance_of

  # We're not using Devise's confirmable to make users confirm their email addresses. But we're sending them an email telling them that they've signed up.
  after_create :email_user_signup_confirmation

  def email_user_signup_confirmation
    Notifications.deliver_signup_confirmation(self)
  end

  def full_name
    "#{first_name} #{last_name}"
  end


  # Search for usernames case-insensitively. It'd be easier to set a case-insensitive collation on the column in the DB (we wouldn't need find_first_by_username or find_for_authentication), but that's database-dependent.
  # Note that case is preserved when creating the account, so we can't just upcase/downcase the username we're looking for.
  def self.find_first_by_username(username)
    self.find(:first, :conditions => ['LOWER(username) = ?', username.downcase])
  end

  # Make Devise check usernames case-insensitively.
  def self.find_for_authentication(conditions)
    username = conditions[:username] # NOTE: Due to our Devise configuration, this will be the only key in the conditions hash.
    self.find_first_by_username(username)
  end

  def self.search(query, options={})
    scope = self.scoped(:limit => 100, :include => :bio, :conditions => ['(first_name LIKE :query OR last_name LIKE :query OR username LIKE :query)', {:query => "%#{query}%"}])
    [:location, :title, :industry].each do |field_type|
      scope = scope.scoped(:joins => :bio, :conditions => ["#{field_type.to_s} LIKE ?", "%#{options[field_type]}%"]) if !options[field_type].blank?
    end
    scope
  end

  def follow(user_to_follow, networks)
    networks = [networks].flatten # Allow networks to accept a single network or an array of networks.
    networks.each do |network|
      network = network.name if network.is_a?(Class) # Allow networks to be passed by name or class.
      Connection.create(:follower => self, :followee => user_to_follow, :network => network)
    end
  end

  def unfollow(user_to_unfollow, networks)
    networks = [networks].flatten # Allow networks to accept a single network or an array of networks.
    networks.each do |network|
      network = network.name if network.is_a?(Class) # Allow networks to be passed by name or class.
      connection = Connection.find(:first, :conditions => ['follower_id = ? AND followee_id = ? AND network = ?', self.id, user_to_unfollow.id, network])
      Connection.destroy(connection.id)
    end
  end

  def following?(other_user, network=nil)
    if network
      network = network.name if network.is_a?(Class) # Allow networks to be passed by name or class.
      connection = Connection.find(:first, :conditions => ['follower_id = ? AND followee_id = ? AND network = ?', self.id, other_user.id, network])
    else
      connection = Connection.find(:first, :conditions => ['follower_id = ? AND followee_id = ?', self.id, other_user.id])
    end
    return !!connection
  end

  def followees
    connections.collect(&:followee).uniq
  end

  # Networks that this user has accounts on.
  def networks
    self.accounts.collect(&:network_name)
  end

end
