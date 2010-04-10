class CreateSocialNetworkAccounts < ActiveRecord::Migration
  def self.up
    create_table(:social_network_accounts) {}
    add_column    :social_network_accounts, :network_name, :string
    add_column    :social_network_accounts, :username, :string
    add_column    :social_network_accounts, :uid, :string
    add_column    :social_network_accounts, :full_name, :string
    add_column    :social_network_accounts, :token, :text
    add_column    :social_network_accounts, :user_id, :integer
  end
  def self.down
    drop_table    :social_network_accounts
  end
end
