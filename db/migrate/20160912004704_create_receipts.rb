class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.date :pd
      t.integer 'items', array: true
      t.timestamps null: false
    end
  end
end
