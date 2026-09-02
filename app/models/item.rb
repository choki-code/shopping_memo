class Item < ApplicationRecord
  belongs_to :shopping_list
  validates :name, presence: true
end
