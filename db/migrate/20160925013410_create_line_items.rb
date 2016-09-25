class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.belongs_to :item, index: true
      t.belongs_to :receipt, index: true

      t.timestamps null: false
    end
  end
end
