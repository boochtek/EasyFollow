class CreateBios < ActiveRecord::Migration
  def self.up
    create_table(:bios) {}
    add_column    :bios, :location, :string
    add_column    :bios, :title, :string
    add_column    :bios, :industry, :string
    add_column    :bios, :description, :text
    add_column    :bios, :user_id, :integer
  end
  def self.down
    drop_table    :bios
  end
end
