require 'spec_helper'

describe User do
  let(:user) { Factory :user }
  subject { user }

  it { should be_valid }

  it { should validate_presence_of :login }
  it { should validate_uniqueness_of :login }
  it { should ensure_length_of(:login).is_at_least(2).is_at_most(50) }
  it { should allow_values_for(:login, 'jo', 'CraigBuchek', 'craig_buchek', 'Craig-1970!', 'craig@boochtek.com', 'Booch!', 'home_style') }
  it { should_not allow_values_for(:login, nil, '', ' ', 'Craig Buchek', 'a/b', 'c', '10%', '1+1', 'Hello?', '$14', 'User#login', 'Was_(not_was)', '6*9') }
  it { should_not allow_values_for(:login, *User::PROHIBITED_USERNAMES) }
  it { should_not allow_values_for(:login, 'test.html', 'anything.php', 'something.css', 'xyz.js', '.ico') }

  it { should validate_presence_of :email_address }
  it { should ensure_length_of(:email_address).is_at_least(6).is_at_most(100) }
  it { should allow_values_for(:email_address, 'craig@boochtek.com', 'greg.mattison@habanero.co', 'A@b.it', 'abc@news.museum') }
  it { should_not allow_values_for(:email_address, nil, '', ' ', 'a@b') }

  it { should validate_presence_of :first_name }
  it { should ensure_length_of(:first_name).is_at_most(50) }
  it { should allow_values_for(:first_name, 'D', 'D.', 'W.E.B.' 'Craig', 'Habanero, Inc.', 'd/b/a Habanero') }
  it { should_not allow_values_for(:first_name, nil, '', ' ') }

  it { should ensure_length_of(:last_name).is_at_most(50) }
  it { should allow_values_for(:last_name, '', 'Buchek', 'Buchek, III', 'Buchek, Jr.', 'Smith-Jones') }

  describe 'login' do
    it 'should not allow duplicate login IDs (case-insensitive)' do
      user1 = User.new(Factory.attributes_for(:user, :login => 'CraigBuchek'))
      user1.save
      user2 = User.new(Factory.attributes_for(:user, :login => 'craigbuchek'))
      user2.should_not be_valid
      user2.should have_errors_on(:login)
    end
  end
end
