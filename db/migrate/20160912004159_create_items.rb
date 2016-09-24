class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :barcode
      t.decimal :price
      t.boolean :tax
      t.boolean :pp
      t.string :name
      t.integer :inventory_id
      t.integer :receipt_id

      t.timestamps null: false
    end
  end
end
