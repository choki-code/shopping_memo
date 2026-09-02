class CreateShoppingLists < ActiveRecord::Migration[8.1]
  def change
    create_table :shopping_lists do |t|
      t.string :name
      t.text :memo

      t.timestamps
    end
  end
end
