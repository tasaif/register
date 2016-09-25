class Item < ActiveRecord::Base
  has_many :line_items

  def stamp(line_item)
    line_item.barcode = self.barcode
    line_item.price = self.price
    line_item.tax = self.tax
    line_item.pp = self.pp
    line_item.name = self.name
  end
end
