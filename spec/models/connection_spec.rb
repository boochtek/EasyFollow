require 'spec_helper'

describe Connection do

  let(:user1) { u = Factory :user;  u.accounts << Factory(:twitter);  u }
  let(:user2) { u = Factory :user2; u.accounts << Factory(:twitter2); u }
  let(:connection) { Connection.create(:follower => user1, :followee => user2) }
  subject { connection }

  it { should be_valid }

  it { should validate_presence_of :follower }
  it { should validate_presence_of :followee }

  it { should allow_values_for(:networks, ['linked_in'], ['linked_in', 'twitter'], ['twitter', 'linked_in']) }
  it { should_not allow_values_for(:networks, 'twitter linked_in', ' ', ['twitter linked_in']) }

end
