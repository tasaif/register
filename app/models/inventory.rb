class Inventory < ActiveRecord::Base
  has_many :items
end
