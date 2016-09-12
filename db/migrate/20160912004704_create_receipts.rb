class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.date :pd

      t.timestamps null: false
    end
  end
end
