require 'spec_helper'

describe Connection do

  let(:user1) { Factory :user }
  let(:user2) { Factory :user2 }
  let(:connection) { c = Connection.create(:follower => user1, :followee => user2); c.networks = 'Twitter'; c }
  subject { connection }

  it { should be_valid }

  it { should validate_presence_of :follower }
  it { should validate_presence_of :followee }
  it { should validate_presence_of :networks }

  it { should allow_values_for(:networks, ['linked_in'], ['linked_in', 'twitter'], ['twitter', 'linked_in']) }
  it { should_not allow_values_for(:networks, 'twitter linked_in', ' ', [], ['twitter linked_in']) }


end
