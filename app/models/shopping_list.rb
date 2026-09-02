class ShoppingList < ApplicationRecord
  validates :name, presence: true
end
