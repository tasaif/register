class Receipt < ActiveRecord::Base
  has_many :line_items

  def lines_to_items
    return self.line_items.collect{|line_item| line_item.item}
  end

  def subtotal
    costs = line_items.collect { |line_item| line_item.cost(pretax: true) }
    costs.reduce :+
  end
  def total
    costs = line_items.collect { |line_item| line_item.cost }
    costs.reduce :+
  end
end
