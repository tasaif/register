class Receipt < ActiveRecord::Base
  has_many :line_items

  def lines_to_items
    return self.line_items.collect{|line_item| line_item.item}
  end
end
