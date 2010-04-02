class Person < ActiveRecord::Base
  attribute :name, :string, :unique => true, :required => true, :validate_as => :name
  attribute :age, :integer
  attribute :serial_number, :float, :read_only => true
#  attribute :price, :decimal, :precision => 10, :scale => 2, :null => false, :default => 1.00
  attribute :title, :string, :validate_as => :name
  attribute :body, :text, :default => ''
  attribute :quantity, :integer, :limit => 4
  attribute :new, :string, :default => "brand new"
  belongs_to :company
  belongs_to :manager
end
