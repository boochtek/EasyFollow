require 'spec_helper'

describe User do
  let(:user) { Factory :user }
  subject { user }

  it { should be_valid }

  it { should validate_presence_of :username }
  it { should validate_uniqueness_of :username }
  it { should ensure_length_of(:username).is_at_least(2).is_at_most(50) }
  it { should allow_values_for(:username, 'jo', 'CraigBuchek', 'craig_buchek', 'Craig-1970!', 'craig@boochtek.com', 'Booch!', 'home_style') }
  it { should_not allow_values_for(:username, nil, '', ' ', 'Craig Buchek', 'a/b', 'c', '10%', '1+1', 'Hello?', '$14', 'User#username', 'Was_(not_was)', '6*9') }
  it { should_not allow_values_for(:username, *User::PROHIBITED_USERNAMES) }
  it { should_not allow_values_for(:username, 'test.html', 'anything.php', 'something.css', 'xyz.js', '.ico') }

  it { should validate_presence_of :email }
  it { should ensure_length_of(:email).is_at_least(6).is_at_most(100) }
  it { should allow_values_for(:email, 'craig@boochtek.com', 'greg.mattison@habanero.co', 'A@b.it', 'abc@news.museum') }
  it { should_not allow_values_for(:email, nil, '', ' ', 'a@b') }

  it { should validate_presence_of :first_name }
  it { should ensure_length_of(:first_name).is_at_most(50) }
  it { should allow_values_for(:first_name, 'D', 'D.', 'W.E.B.' 'Craig', 'Habanero, Inc.', 'd/b/a Habanero') }
  it { should_not allow_values_for(:first_name, nil, '', ' ') }

  it { should ensure_length_of(:last_name).is_at_most(50) }
  it { should allow_values_for(:last_name, '', 'Buchek', 'Buchek, III', 'Buchek, Jr.', 'Smith-Jones') }

  describe '#username' do
    it 'should not allow duplicate username IDs (case-insensitive)' do
      user1 = User.new(Factory.attributes_for(:user, :username => 'CraigBuchek'))
      user1.save
      user2 = User.new(Factory.attributes_for(:user, :username => 'craigbuchek'))
      user2.should_not be_valid
      user2.should have_errors_on(:username)
    end
  end

  describe '#follow' do
    # TODO
  end

  describe '#following?' do
    # TODO
  end

end
