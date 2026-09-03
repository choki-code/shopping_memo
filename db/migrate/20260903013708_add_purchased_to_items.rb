class AddPurchasedToItems < ActiveRecord::Migration[8.1]
  def change
    add_column :items, :purchased, :boolean, default: false, null: false
  end
end
