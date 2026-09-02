class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.string :name
      t.references :shopping_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
