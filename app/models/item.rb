class Item < ApplicationRecord
  belongs_to :shopping_list
  validates :name, presence: true
  scope :unpurchased, -> { where(purchased: false) }
  scope :purchased, -> { where(purchased: true) }
end
