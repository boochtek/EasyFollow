class UpdateUsers20100402122203 < ActiveRecord::Migration
  def self.up
    add_column    :users, :accept_terms, :boolean, :default => false
  end
  def self.down
    remove_column :users, :accept_terms
  end
end
